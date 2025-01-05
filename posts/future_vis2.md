# We need more visualization libs - and a protocol to bind them

<!-- DATE:  2015-10-20 -->
<!-- TAGS: visualization, python, web, opengl -->
<!-- AUTHOR: Almar -->

We have a rich ecosystem of visualization libraries, each with their
own API. By splitting our libraries in a user-facing part and a
rendering backend, and defining a standard to allow all these to
connect, we can have a rich visualization ecosystem while users only
have to learn one API.

<!-- END_SUMMARY -->

![Escher's study of reptiles](images/escher_reptiles.jpg)
<br /><small><i>
Image by Escher via Wikimedia (fair use)
</i></small>

----

## The problem

As I mentioned in a [previous post](https://almarklein.org/future_vis.html),
we seem to be getting different visualization libraries which are each
good at a particular task. I mentioned Bokeh and Vispy in particular:
the former does very well in the browser, but it can't do 3D. The latter
has awesome performance by making use of the GPU, but it does not work
(well) in the browser. And neither can export vector images like
Matplotlib does. The fact that we get more and more cool visualization
libraries is awesome, but it's not making it easier for our users, which
are usually researchers who just want to get things done.

Imagine a scientist who works with 3D data, who makes some plots
that should be shared online, which also need to export to EPS for a
paper. This person would now need to learn three different visualization
libraries.

*The main problem is that users need to learn different API's to perform
different visualization tasks.*


## Building a monolithic library that is good at everything is *not* a good idea

The solution I proposed earlier was basically to discuss building a new
library that has it all. After thinking this over, I think that's a
terrible idea:

* It will be a tremendous effort, if only to get the right people together.
* Building something that can do what Vispy can do, and at the same
  time render in a browser like Bokeh can, would be challenging, and
  would result in a complex design.
* It's impossible to include all potential features. Even if we could
  create something that has all the features people need today, tomorrow
  someone will need something else, and the design might not be flexible
  enough to add such a feature.

I think that there is a better approach to fix the problem. One
that is less crazy, and allows for a much easier transition.


## We need a split

If we separate the user API and the rendering part of a visualization
system, and define a protocol for the communication between the two,
it should be possible to connect different rendering systems to the
same front-end (i.e. user API); the user only needs to learn how to work
with one library, and can switch between rendering backends depending
on the needs (e.g. rendering to SVG, rendering something 3D, or
rendering in a browser).

<img width=450 src='images/vis_split.svg' />

By defining a formal protocol and separating user-targeted front-ends
from rendering back-ends each part can focus more on one particular
task. Front ends focus on allowing the user to effectively spelling out
a visualization, while backends focus on rendering a visualization in a
particular way, supporting a particular set of rendering primitives
(e.g. Vispy supports volumes, Matplotlib supports pie charts).

I suspect that the number of front-ends will first expand and then
settle on a few common libraries. For the rendering backends, I think
we would see a much broader array of options, including tools to support
very specific visualizations.


## State of the art

This idea is not new. [Altair](https://github.com/ellisonbg/altair) for
instance, proposes something very similar. Also Bokeh is somewhat
organized in these two parts, except that the protocol is not
standardized.

However, the above projects are very much aimed at visualizing the
relation between 2 or more 1D data structures (i.e. plotting and
charts). The visualization of 3D data, let alone fancy specific data
structures seems an afterthought.

Further, these approaches are based on the serialization of a scene
into one static representation (e.g. a JSON structure). What about
interaction? What about *changes*? Bokeh does interaction with the
Python process via the backbone model and AJAX to update data, but can
we not make this part of the protocol?


## Proposal

Instead of defining a static data structure, I think we should formalize
a protocol to represent *changes*.

Here's a stab at what such a protocol might look like: consider a simple
core set of commands to create a tree of objects with attributes. Each
command consists of a message written as a "tuple". This tuple can exist
as an object, or be serialized so it can be send over a socket or saved
to disk. There are just three commands to manipulate objects:

* `('create', type, object_id)`
* `('delete', object_id)`
* `('set', object_id, attr_name, value)`

The code that produces these commands should manage the object_id's of
the objects. For data we need something similar, allowing setting and
(partial) updating of data:

* `('data_create', data_id, shape, dtype)`
* `('data_delete', data_id)`
* `('data_set', data_id, offset, bytes)`

The renderer can also communicate back (e.g. when the value of a slider has changed):

* `('set', object_id, attr_name, value)`

These commands form a foundation, on top of which we can define a
standard set of "types" and their "attributes". E.g. we can define that the
"Line" type shows a line, and that it has attributes "width" and
"color". The formulation of the standard would be an ongoing process and should
probably involve a group of people with representatives from all major
visualization libraries.

Naturally, each rendering library can also specify its own types, e.g. Vispy
would have a objects with attributes to allow custom shading. Similar,
rendering libraries do not necessarily have to import each part of the
standard (e.g. Vispy may not support pie charts).


## An example

Here is an example of how this protocol could like for a simple plot with
a red line:

```python
('create', 'Plot', 'plot1')
('create', 'Line', 'line1')
('set', 'line1', 'parent', 'plot1')  # Make the line a child of the plot
('data_create', 'data1', (100,1), 'float32')
('data_set', 'data1', 0, b'000as...')
('data_create', 'data2', (100,1), 'float32')
('data_set', 'data2', 0, b'f7a41...')
('set', 'line1', 'x', 'data1')  # Set x to data with id 'data1'
('set', 'line1', 'y', 'data2')
('set', 'line1', 'color', '#ff0000')  # make the line red
```

This is not as readable as a JSON structure would be, but the point is
that changes can be handled by just adding commands. Also, it's trivial
to transform a series of commands to a JSON structure, or the other way
around.


## Further thoughts

Having the proposed protocol in place would mean that Bokeh and Vispy
can keep doing what they're good at, and let exporting to vector
graphics be handled by Matplotlib. New user-facing libraries like
[Holoviews](http://ioam.github.io/holoviews/) would just work for all
available rendering engines. And new rendering engines like what
[Cyrille Rossant proposes](http://cyrille.rossant.net/compiler-data-visualization/)
should just work without the user having to change the code. Also, I would
love to make a simple volume renderer in WebGL, which would allow
existing code for displaying a volume to be exported to static HTML.

Maybe we could eventually have some sort of auto-selection for the
backend, such that visualizations get shown in the backend that is most
capable of handling what the user spelled out. If that works well,
people could make dedicated renders for specific visualizations, which
would Just Work for any user.


## Summary

Here's what I think we need to do to make Python's visualization ecosystem
more friendly and powerful:

* We should define a standard to describe visualizations.
* We should split up our current visualization libraries in parts that
  are either user-facing or rendering backend.
* The protocol should describe changes, rather than a static scene.

In this way, a user can learn just one API and still "have it all",
by using a different rendering backend for different needs.
