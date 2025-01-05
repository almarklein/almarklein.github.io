# viz interactive

<!-- DATE: -->
<!-- TAGS: viz -->
<!-- AUTHOR: Almar -->

## Visualization gets more interactive

Ten years ago, visualization usually meant writing some code to define
the visualization, which then produced a static image for display (A
in the image below). Over the years, visualization has become
increasingly interactive. I distinguish between mouse interaction (e.g.
panning and zooming) and custom interaction (e.g. reacting to a slider
move or a click on an object in the visualization).

<img width=450 src='images/visualization_interaction_models.svg' />

Interaction in its simplest form (B) is implemented in Python
(though a similar story holds for other languages as well); mouse
interaction is captured, and the visualization is updated. In Matplotlib
this means re-creating the visualization from scatch. In
[Vispy](http://vispy.org) (which is OpenGL-based) this means updating
GPU variables. This approach works fine, but it has limitations with
respect to publishing, because you basically have to go back to A when
you need something that you can put online. (Note that both Matplotlib
and Vispy *can* work in the browser, but they need a Python process to
do the interaction.)

As the web became more important and JavaScript became faster, the
people behind projects like [Bokeh](http://bokeh.pydata.org) and
[MPLD3](http://mpld3.github.io/) realized how a browser could be used
for publishing visualizations (subfigure C). Mouse interaction is
implemented in JavaScript, which means that it works without Python.
If Python is connected, more advanced interaction is possible.

A logical next step is to allow defining custom interaction in JavaScript
as well, which makes it possible to display very rich visualizations
in static web pages (D). It's not hard to see that this offers great
opportunities for sharing scientific results. Bokeh has
functionality for this, allowing the definition of callback routines
in JavaScript (and soon will support writing these in Python, which is
then transpiled to JavaScript). 
