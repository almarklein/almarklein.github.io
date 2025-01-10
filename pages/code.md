# Code

This is an overview of projects that I work on (or have worked on).


## Visualization

### Previous work

<img style="float: right; margin:10px;" src="https://raw.githubusercontent.com/wiki/almarklein/visvis/images/overviewScreen.png" width="300px"/>

My first visualization library, [Visvis](https://github.com/almarklein/visvis), is a pure Python library for visualization of 1D to 4D data in an object oriented way. Visvis is mature, though a bit idiosyncratic. It served me well during my Phd, but I am not actively developing it anymore, except fixing bugs and keeping it running on the latest Python.

In 2012 I founded the [Vispy](https://github.com/vispy/vispy) project together with Luke Campagnola Nicolas Rougier, and Cyrille Rossant. It was purposed to replace each of our own projects, including Visvis. However, we've made the scope too big and all of us left for various reasons before it was finished. David Hoese heroically maintained the project for many years.

### Pygfx

<img style="float: right; margin:10px;" src="https://pygfx.org/pygfx1024.png" width="160px"/>

In 2020 Korijn van Golen and I started working on a new viz stack based on WebGPU. We  built a Python wrapper, [wgpu-py](https://github.com/pygfx/wgpu-py), on top of which we built a 3D render engine: [pygfx](https://github.com/pygfx/pygfx).

The [rendercanvas](https://github.com/pygfx/rendercanvas) is used in the above to provide a canvas to render to.
The [jupyter_rfb](https://github.com/vispy/jupyter_rfb) library provides a way for
visualization libraries (like Vispy and Pygfx) to show figures in Jupyter lab/notebook.


<div style='clear: both;'></div>
## Pyzo IDE

<img style="float: right" src="images/pyzologo128.png" />

[Pyzo](https://github.com/pyzo/pyzo) is a cross-platform Python IDE focused on
interactivity and introspection, which makes it very suitable for
scientific computing. We have developed Pyzo to have a simplistic design
while still providing a powerful programming environment; all the good
stuff, without the clutter.

Pyzo is my longest running project. I've not been able to work
on it very actively lately, but [bdieterm](https://github.com/bdieterm) is
doing a lot of work to move Pyzo forwards.


<div style='clear: both;'></div>
## Zoof programming language

My secret dream is to create a new programming language based on WebAssembly.
From time to time I create some time to hack on [Zoof](https://github.com/zoof-lang/zoof-boot).

Also a shout out to Robert Nystrom's [Crafting Interpreters](https://craftinginterpreters.com/), it's an awesome book if you have an interest in how
programming languages work!


<div style='clear: both;'></div>
## TimeTagger

<img style="float: right" width=96 src="images/timetagger192_sf.png" />

[TimeTagger](https://github.com/almarklein/timetagger) / ([timetagger.app](https://timetagger.app)) is an open source time tracking app, with a focus on devs; it has a public web API, and a CLI tool: [timetagger_cli](https://github.com/almarklein/timetagger_cli). Grown out of frustration with existing solutions, a drive to create something refreshing, and an attempt to generate a passive income.


<div style='clear: both;'></div>
## Web backend

As I gained an interest for the web, I developed a few small tools.
TimeTagger uses some of these, and the website that you're
visiting now is using all of the below :)

[Asgineer](https://github.com/almarklein/asgineer) is a truely
minimalistic async web framework based on the awesome
[Uvicorn](https://github.com/encode/uvicorn/). It allows one to create bloody
fast web servers that are easy to maintain.

[Fastuaparser](https://github.com/almarklein/fastuaparser) is a small utility
to parse user-agent strings, focussed on speed.

[ItemDB](https://github.com/almarklein/itemdb) is a small library that
provides a simple API to store and retrieve (JSON-compatible) Python
dicts in an SQLite database.

[MyPaas](https://github.com/almarklein/mypaas) is a tool to manage a
PaaS using Traefik and Docker, e.g. to run multiple websites.


<div style='clear: both;'></div>
## IO

### Images

<img style="float: right" src="https://avatars2.githubusercontent.com/u/3678179?v=2&s=150" width="150px"/>

[Imageio](https://github.com/imageio/imageio) aims to support reading
and writing a wide range of image data, including animated images,
volumetric data, and scientific formats. It is designed to be powerful,
yet simple in usage and installation. It is also easy to extend new
formats to imageio. Sebastian Wallkötter is currently the official maintainer.

The [imageio-ffmpeg](https://github.com/imageio/imageio-ffmpeg) project
is a spin-off of imageio, to handle the task of reading and writing
videos. You should probably use the newer [PyAV](https://github.com/PyAV-Org/PyAV/) instead.

I've developed encoders/decoders for a variety of image file formats. Some
have become part of imageio. [ppng](https://github.com/almarklein/ppng) is a more recent project.

### Generic storage

The [Binary Structured Data Format](https://gitlab.com/almarklein/bsdf) (BSDF) is an open
specification for serializing (scientific) data, for the purpose of
storage and (inter process) communication. It's designed to be a simple
format, making it easy to implement in many programming languages.

### Inter-process

[Yoton](https://github.com/pyzo/pyzo/tree/main/pyzo/yoton) is a small (zero-dependency) tool for inter-process communication, used by the Pyzo IDE.


<div style='clear: both;'></div>
## Python in the browser

I've long had an interest in running Python in the browser, and developed
a few tools to this end. However, I no longer believe that there's a good solution to
do this. Pyodide may be the best approach, though it suffers from long load times.

[PScript](https://github.com/flexxui/pscript) is a Python to JavaScript compiler,
enabling writing JavaScript using a Python syntax, and handling several (but not
all) JavaScript pitfalls.

<img style="float: right" src="https://raw.githubusercontent.com/zoofIO/flexx/master/flexx/resources/flexx.ico" width="128px"/>

[Flexx](https://github.com/flexxui/flexx)
is a pure Python toolkit for creating graphical user interfaces
(GUI’s), that uses PScript and web technology for its rendering. You
can use Flexx to create desktop applications, web applications, and (if
designed well) export an app to a standalone HTML document.
Flexx is pretty powerful, but it turns out to be easy to create code with
it that becomes hard to maintain, because its so easy to mix real Python
with Python that runs in the browser (PScript). This makes these tools less
suited for wide adoption.

[Webruntime](https://github.com/flexxui/webruntime) can be used to launch applications based on HTML/JS/CSS. Either in a browser or in something that looks like a desktop app.


<div style='clear: both;'></div>
## Research

Visvis and Pyzo originated during my PhD. I also created a few more specialistic tools.

[PIRT](https://github.com/almarklein/pirt) (the Python Image Registration Toolkit), is a project to make powerful image registration algorihms easily accessible. It wraps PyElastix and also includes custom algorithms, including a diffeomorphic version of the Demons algorithm. Originally written in Cython, but now that it uses Numba it is pure Python (i.e. much easier to install).

[PyElastix](https://github.com/almarklein/pyelastix) is a project that has spun out of the PIRT project. It provides a Pythonic interface to the awesome Elastix image registration toolkit. I created this (pure Python) library to enable people to do image registration in a simple way, while making it easy to maintain.

[Stentseg](https://github.com/almarklein/stentseg) is a library to perform segmentation of stent grafts in CT data. Mostly developed during my PhD, but in a rather good state. I managed to make it Pure Python by moving a critical part (a specific variant of the MPC algorithm) to scikit-image.


<div style='clear: both;'></div>
## Misc

[Dialite](https://github.com/flexxui/dialite) is a small Python library
to present the user with a dialog. It has no dependencies; it only uses OS utilities.
Used by Flexx, and by Pyzo to show info to the user if Qt fails.
