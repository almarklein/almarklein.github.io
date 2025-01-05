# Scientists need a dynamic programming language

<!-- DATE: 2014-09-20 -->
<!-- TAGS: python, science, matlab -->
<!-- AUTHOR: Almar -->

Dynamic programming languages provide great advantages due to
their interactive workflow, especially in science where algorithms are
complex and take many iterations to get right. Developer time is more
important than CPU time; writing all your code in a static language is
(often) a bad case of premature optimization.

This post is a story about how I learned the importance of dynamic
languages the hard way. I am sharing it here so that others might learn
from it too. It also touches on some of the benefits of Python compared
to Matlab.

<!-- END_SUMMARY -->

![A Starry night](images/starrynight.jpg)
<br /><small><i>
Image by Van Gogh (public domain)
</i></small>

----

## Searching for an alternative to Matlab

Like most PhD students at my university, I started out with Matlab to do
my programming. I liked it a lot, and over time got quite
experienced. I also used Matlab at home for a few hobby projects,
but for that I needed to resort to an illegal version, which always
felt a bit awkward.

As I grew more adept using Matlab, I also started to realize some of
its fundamental
[quirks](http://www.pyzo.org/python_vs_matlab.html#the-problem-with-matlab)
stemming from its origin as a matrix manipulation package.
What finally drove me into looking for alternatives was the fact that
I was working with dynamic CT data, and I wanted to visualize dynamic
volumes together with segmentation results. Good luck with that in
Matlab.

Near the end of 2007, when I was almost a year in my PhD project, a
colleague and myself started looking for alternatives, and were quite
impressed with [VTK](http://vtk.org). Since we could not use it from
Matlab, we considered using C++ or C#. We eventually settled on C#,
because it is a very pleasant language overall, and makes creating GUI's
very easy. We used a C# wrapper for VTK that someone had fortunately made
available.

## Getting serious with C-sharp

In February 2008 two other colleagues joined us and we started to design
a framework where algorithms could be represented as building blocks
with predetermined input and output ports (similar to VTK). One big
motivator was that students and ourselves could build such building
blocks which could then easily be reused by others. We hoped that this
would solve the all-too-frequent problem that code developed by students
was usually lost and forgotten after the student left. The combination
of C# with VTK offered us a number of advantages:

* Code reuse
* Speed
* 3D visualization
* Easy building of GUI's
* Create portable apps
* Object oriented code
* Free (as in beer)

That seemed like a pretty good list. Full of
enthusiasm and high expectations we started implementing this
"framework", which we had called "POT" (I can't remember what the acronym
meant, but it was unrelated to cannabis). We put a lot of energy into
it and things were looking pretty good. We could interface with VTK and
Matlab, and we even had a UI in which you could drag blocks around and
connect them to each-other. We had high hopes and started to suggest
our ideas to other members in our group.

## Realizing that C-sharp was not it

Then came the moment that I started using the framework myself, by
porting some Matlab code to C#. I remember that it was a
Friday. I quickly ran into problems with porting my algorithms. I was
used to a rapid-prototyping approach: make a small script with a minimal
example and then expand and develop it further while repeatedly
executing it in the running process. Not in C#. Create a new project,
add references, build a small GUI, etc. And then running … if it does
not work (which is usually the case the first X times you try) so one
needs to debug. Find the bug, exit debugger, fix bug, run again, repeat
...

That's when I realized that I had tremendously underestimated the
flexibility of Matlab. This realization came as a lightning strike.
That Friday was the last day that I used our framework (and C# for that
matter). The months of effort turned out to be a waste of time. I learned
an important lesson though, and I never forgot it.

## Defeat ... and victory!

Reluctantly I went back to Matlab. I started experimenting with Matlab's
new functionality for classes, and I did some experiments to use OpenGL
via DirextX (I had already discarded VTK due to it's sheer
size and verbose API). About two weeks later I ran into the [blog
post](http://vnoel.wordpress.com/2008/05/03/bye-matlab-hello-python-thanks-sage/)
that changed my life.

After learning about [Python](http://python.org) I experienced the same
symptoms of being in love (don't tell my wife) and I barely slept for
3 days. I realized very soon that Python had been exactly what I was
looking for. It ticked all the boxes.

Python is a beautiful language. After using Python for a while, many
things in Matlab seemed very awkward. Like indexing, string
manipulation, building GUI's, creating classes. Even the fact that you
need one file for each function definition seemed so primitive in
retrospect! There has not been a single moment when I regretted the
move to Python.

On the other hand, the scientific ecosystem was a bit immature at that
moment, which meant that I had to get my hands dirty and become active
in developing tools. I am still doing this today, and I love doing it!

## What I learned

The important lesson that I learned is that the list mentioned above
misses one very important element: interactivity. I realize now that
for scientific computing a highly interactive workflow is incredibly
beneficial for your productivity. You can work with your code
in a very direct and effective manner, by allowing you to execute code
in a running process, redefine functions without having to reload your
data, and introspect many aspects of your code during runtime. Dynamic
languages like Matlab provide this, compiled languages like C# do not.

I think this realization has also been an important factor in the
development of [IEP](http://iep-project.org). Many ideas were in fact
inspired by how Matlab allows code execution, like being able to execute
a cell (a piece of code between two double comments `##`).

## Languages side by side

So let's have a look at the list again (the complete version this time),
and see how C#, Matlab and Python compare:

* **Code reuse:** this could have worked in our framework, except that the learning
  curve is too steep to let our students work with C#. Code reuse in
  Matlab is always a bit messy, since you have to fiddle with paths.
  In Python we have packages and modules.
* **Speed:** yes, C# is faster than Matlab and Python, but there are many
  ways to deal with this. Matlab has Mex-files, Python has
  [Cython](http://www.cython.org/), [Numba](http://numba.pydata.org/)
  and other solutions. Choosing a compiled language as a primary
  development tool may just be a bad case of premature optimization, because
  an interactive workflow increases development speed (and fun), which
  is often more important than a high runtime speed.
* **3D visualization:** I started making friendly Python wrappers to OpenGL. This culminated
  in [Visvis](http://code.google.com/p/visvis/) and now [Vispy](http://vispy.org).
* **Easy building of GUI's:** good in C#, terrible in Matlab, in Python we
  have Qt, WX, and others.
* **Create portable apps:** Matlab has the MCR but this is not very
  reliable, pretty nor compact. On Python you can freeze your code into
  a compact standalone application.
* **Object oriented:** available in Matlab. Very nicely done in Python.
* **Free:** Python is free as in speech and as in beer. Matlab definitely not.
* **Dynamic:** Python and Matlab are both dynamic languages that allow
  an interactive workflow.

## Conclusion

For most scientists it would be most productive to use a dynamic
language, and only use a compiled language (or other tools) to make the
crucial bits of code faster.

Python is currently one of the best choices, although statisticians may
also like [R](http://www.r-project.org/). Further, there are very
interesting languages being developed right now (e.g.
[Pypy](http://pypy.org) and [Julia](http://julialang.org)), and I
suspect there will be more of that in the future.
