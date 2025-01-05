# The future of visualization in Python - are we going where we want to be?

<!-- DATE: 2015-08-02 -->
<!-- TAGS: viz, python, web, opengl -->
<!-- AUTHOR: Almar -->

Bokeh and VisPy are both awesome projects. However, I wonder
whether we need to change where things are currently going. While Bokeh
is great at 2D and the browser, 3D is not supported. While Vispy is
super-fast and good at 3D and custom visualizations, it's support for
the browser is poor. I don't want to tell scientists that they need two
or three visualization libraries. I want it all in one library.


<!-- END_SUMMARY -->


![Escher's hand with reflectice sphere](images/escher_sphere.jpg)
<br /><small><i>
Image by Escher via Wikimedia (fair use)
</i></small>

----

## Pride and discomfort

A short while ago, I was watching the talks from SciPy 2015 about
[Bokeh](https://www.youtube.com/watch?v=c9CgHHz_iYk) by Bryan Van de Ven
and [VisPy](https://www.youtube.com/watch?v=_3YoaeoiIFI) by Luke Campagnola.
Being involved in both these projects, I felt very proud at seeing how
both these projects are progressing. Both projects are awesome in their own way
and really change the way that scientists can do visualization in Python.

At the same time, however, I felt a certain sense of discomfort. At first
I was not sure why this was, but it was in part triggered by a question
from the audience at the end of the VisPy talk about whether the VisPy
and Bokeh projects can be combined in some way.

I don't think they can.

Bokeh is very much aimed at 2D plotting and does all its rendering in
JavaScript. VisPy has strong support to allow 3D visualization, but does not
have good browser support. Combining the two projects would essentially
mean a rewrite.

And this is the thing that bothers me; both projects offer something
great, but both also lack a fundamental feature that is essential to
becoming *the* visualization library.


## Bokeh

Bokeh was written from the start to render in the browser. The drawing
system is implemented in CoffeeScript (which is compiled to JavaScript),
which means that interactions with the plot can work without a Python
(server) process.

I think this is essential for a visualization library of the future.
Scientists want to share their results using interactive visualizations,
or even small (dashboard) apps. HTML is the obvious medium to achieve
this.

Bokeh uses the 2D canvas for its drawing, which is pretty fast, but not
nearly as fast as WebGL. WebGL is currently being added to Bokeh,
but I'm not sure if we can reach the performance that WebGL might
ideally provide, because Bokeh was not designed to target WebGL from
the start.

There have also been discussions (triggered by user requests) about
adding support for 3D. I have mixed feelings about this, because 3D is very
much an afterthought. Sure, we could add support for a few specific
plot types, but users are going to ask for more. And 3D is always going
to suck, as it does in Matplotlib, because 3D was not a primary target
to start with. For proper 3D support, you need a good scene graph and
first class support for lighting, cameras, etc. You can build a good
2D plotting API on top of a 3D visualization system (if taken into
account from the start), but not the other way around.


## VisPy

VisPy was written from the start to be a very fast and flexible
visualization system, to support 2D, 3D and any special visualization
that a user could think of.

I think this is essential for a visualization library of the future.
Scientists sometimes have weird data that needs to be visualized in
special ways, and 3D is nowadays not a rarity.

VisPy uses OpenGL for its drawing. We did target OpenGL ES 2.0 from the
start, to allow rendering in WebGL and on mobile devices, so we did
have the web in mind to some extend.
However, the browser support of VisPy is implemented at a low level and
goes more or less like this: the Python process sends OpenGL commands
(via a custom format) to the browser to make the visualization appear.
User input (mouse, keyboard) is captured and send to the Python process,
where VisPy's event system takes care of translating and zooming
camera's, etc., which causes an update, and thus new commands send to
the browser. This all works pretty well, except that the visualization
relies on the Python process. As a consequence, VisPy in the browser is not
as snappy as it should be, and it won't work in an exported HTML
document.

Cyrille Rossant has thought of some ideas on how to incorporate e.g.
camera models in JavaScript, but these solutions are complex and do not
scale well to user-defined interactions.


## I want it all

Don't get me wrong: I think both Bokeh and VisPy are awesome. However,
the way things are going now, it looks like we'll be having one library
that's good at interactive 2D plotting via HTML, but sucks at 3D, and
one library that's good at 2D/3D/other visualizations, but sucks on the
web.

And this worries me.

Further, although both Bokeh and VisPy have plans to support svg/eps
export, for the time being Matplotlib is the way to go for publication
quality static images.

Imagine a scientist asking which visualization library she should use.
*"It depends ..."* What if she has 3D data, she wants to share
visualizations with her peers, and wants publication quality figures?
These are not unreasonable or rare requests, and we should be able to
answer: *"Sure, just use this one library!"*

Here is my list of the utopian visualization library:

* Great at 2D, 3D and flexible enough for custom visualizations.
* Leverages the GPU to allow large datasets and still render in real time.
* Targets (or can target) the browser; visualizations in static HTML
should be fully functional and interactive.
* Also works great on the desktop (though this can be achieved via
[Xul/Electron/NW.js](http://flexx.readthedocs.org/en/latest/webruntime/index.html)).
* Supports export to eps and svg.

(Let me know if you think more points should be added.)

*EDIT: In my [next post](https://almarklein.org/future_vis2.html) I
explain that this is actually a bad idea, and that there are other ways
to achieve an easier workflow for our users.*

## Can we have it all?

I'm certain that we can have it all, but I won't pretend it's easy.
To realize such a system, all requirements need to be incorporated from
the start. Modifying either Bokeh or VisPy to support these will
essentially be a rewrite.

One requirement would be that the complete drawing system runs in
JavaScript. That does not sound like a fun implementation task, since
the scene graph, transformations, and camera/interaction models are
complex enough as it is.
Maybe we can use
[PScript](https://pscript.readthedocs.io) (*which was called PyScript at the time of writing*) to write
such a system in JavaScript using a Python syntax. That way we should
be able to reuse some of the code from VisPy.

A compromise from the point of view of Bokeh is that WebGL is not as
widely supported as the 2D canvas, although this is getting much better.

A compromise from the point of view of VisPy is that WebGL is slightly
slower than desktop GL and lacks certain features that are currently
supported in VisPy, such as integration with OpenCL. In
theory, the code could be written in a way to allows running it both
as Python and PyScript, which might solve these issues.

Finally, implementing such a system is a major undertaking. Are there
enough developers on the current projects that are interested in this?
Are there financial resources to get this off the ground? Should we
even try to create a single holistic visualization library?

I don't know. But I think we should at least discuss this.


## Side notes

Khronos (the group responsible for the OpenGL standard) is working on a
new API to target the GPU: Vulcan. This API is lower level and simpler,
and intended for both visualization and compute. Cyrille Rossant wrote a
[blog post](http://cyrille.rossant.net/compiler-data-visualization/) about
targeting it in VisPy. It is not clear yet whether Vulkan will be
available in the browser. If it will, I think we should probably use
that instead of WebGl.


## Final words

I know that what I am proposing is a bit insane. Yet, if we do not take
some form of action, we'll be moving towards a future that is different
from what we need to serve scientists with a proper unified
visualization solution.
