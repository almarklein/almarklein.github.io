# On WebGPU, wgpu-py, and pygfx

<!-- DATE: 2023-02-04 -->
<!-- TAGS: python, viz, gpu -->
<!-- AUTHOR: Almar -->

I'm part of a team building a novel render engine based on WebGPU (the successor to OpenGL). In this post I explain what WebGPU is, how it came about, and how we're using it to power our graphics.

<!-- END_SUMMARY -->



<img src='images/webgpu.png' width='150px' style='float:left; margin:10px;' />

<img src='images/pygfx_with_name.svg' width='200px' style='margin:10px;' />

<div style='clear: both'></div>


## Introductions

Before diving deeper, let's briefly introduce the three names in the title!

[WebGPU](https://gpuweb.github.io/gpuweb/) is:

* An API to control graphics hardware.
* Based on Vulkan / Metal / DX12.
* But higher level than these.
* Not only for the web.



[wgpu-py](https://github.com/pygfx/wgpu-py/) is:

* WebGPU for Python.



[pygfx](https://github.com/pygfx/pygfx) is:

* A modern render engine for Python.
* Based on WebGPU.
* Inspired by ThreeJS.
* But more scientific viz.




## It's all about abstractions

A GPU (Graphics processing unit) is a piece of hardware dedicated to creating images. Driven by the game industry, they have become
impessive machines that can perform massivel parallel computations.

To let programmers control this beast you need an API: a specification for a set of instructions
that programmers can call to create graphics.
And you need a driver that implements this API: a piece of software (often developed by the
hardware manufacturer) that makes the GPU do the work corresponding
to the programmer's instructions.

Examples of such API's that you might have heard of are OpenGL and DirectX. More modern variants are Vulkan, Metal and DX12.

These graphics API's are low level: there are a lot of knobs to turn,
which is why programmers build higher level API's on top. More abstract sets of functions
that are easier to use.

WebGPU is one such abstraction. And pygfx is an even higher-level abstraction built on WebGPU.

<img src='images/pygfx_turtles.png' width='200px' style='margin:10px;' />


## Line counts

These levels of abstraction can be illustrated by looking at the code to
draw a triangle, which is probably the simplest thing one can visualize
on a GPU.

<img src='images/triangle_wgpu.png' height='200px' style='float:left; margin:10px;' />

<img src='images/triangle_pygfx.png' height='200px' style='margin:10px;' />

<div style='clear: both'></div>

* In Vulkan: 700+ lines of code
* In WebGPU: 100+ lines
* In pygfx: ±20 lines


## A bit of history


### OpenGL

OpenGL witnessed the evolution of GPU hardware, and evolved along with it.
As GPU's gained new features, new API surface was added to OpenGL. As
GPU's became more powerful, new abstractions were needed to harnass that power.
In some cases these new abstractions replaced older counterparts, but in the
name of backwards compatibility, the old API stayed.

You can imagine that implementing drivers for OpenGL became increasingly complex.
On top of that, OpenGL has a lot of global state, and all instructions
can happen at any time. It's up to the driver to do the right thing - even
when it might not be clear what this is. Such ambiguities lead to
different behaviours for different drivers/hardware, and are often the cause of
driver bugs.

### Vulkan, Metal and DX12

The response to this was Vulkan: an API that is much lower-level than
OpenGL, with better structure, resulting in clear rules about when
certain instructions are possible. Vulkan is so low level you can almost
touch the hardware, and this was the idea: this makes it much easier
to create reliable drivers!

MacOS decided to develop its own API, called Metal, following a similar strategy as Vulkan. On Windows DX12 followed suit.

Soon after Vulkan became a thing, people started wondering whether there'd be
a WebVulkan. This  - fortunately - never happened.

### WebGPU

Instead, a group of people from Mozilla, Google and Apple started [WebGPU](https://gpuweb.github.io/gpuweb/),
a specification for a graphics API in the browser. They also started building an implementation, called [wgpu](https://github.com/gfx-rs/wgpu).

This wgpu is implemented in the Rust programming language (just like
Firefox). It is itself composed of several layers, but the important
thing is that it uses either Vulkan, Metal or DX12 to talk to the GPU.

Just like WebAssembly, WebGPU is not just for the browser; via [wgpu-native](https://github.com/gfx-rs/wgpu-native) the API is also available
to other languages on the desktop!


## About wgpu-py

We created [wgpu-py](https://github.com/pygfx/wgpu-py) to bring WebGPU to the Python ecosystem. Since the
WebGPU API is specified for JavaScript, we translate it to a Pythonic equivalent API.
The implementation is based on wgpu-native (via cffi).

Since both the WebGPU spec and the wgpu implementation are both under development,
we regularly need to update to their latest versions. This process is partly automated,
but can nevertheless be a [tedious process](https://github.com/pygfx/wgpu-py/issues/289).


## The WGSL shading language

Another interesting thing to note is that for WebGPU they decided on a brand new
shading language called [WGSL](https://www.w3.org/TR/WGSL/). If you
already know e.g. GLSL, the concepts are very familiar, but
the syntax is different (Rust-like, to be specific).


## About pygfx

The pygfx library is much higher-level than WebGPU. It's API is inspired by [ThreeJS](https://threejs.org/) (a popular render engine based on WebGL), but with a special focus on scientific visualisation.

A benefit of basing pygfx on wgpu is a more reliable basis with fewer driver bugs and more consistency across different hardware. Further, in wgpu objects are "prepared" in pipeline objects, which can be drawn with just a few calls, avoiding expensive (Python) overhead. In other words: we can efficiently render large numbers of objects!

### Object model

Pygfx  uses an object model similar to ThreeJS:

<img src='images/pygfx_object_model.png' width='450px' />

This separation of concerns, using `WorldObject`, `Geometry` and `Material` provides high flexibility.
For exampple, the below image shows the same object, with the same geometry, but with different materials applied.

<img src='images/pygfx_model_example.png' width='700px' />

In a similar fashion pygfx has a `Volume` object, which can be
visualized with volume rendering, or using volume slices, by selecting
the corresponding material.

<img src='images/pygfx_vol_code.png' width='400px' />

<img src='images/pygfx_vol1.gif' height='300px' style='float:left; margin:10px' />

<img src='images/pygfx_vol2.gif' height='300px' style='margin:10px'/>

<div style='clear: both'></div>

### Interesting features

Some notable features of pygfx include:

* Builtin antialiasing
* Transparency (order-independent and better)
* Picking system
* Event system



## Summary

I explained how OpenGL is outdated, and is being replaced with Vulkan and friends. WebGPU is a higher level API built on top of these. And that is what we use to create our new render engine, pygfx.

In more detail:

* pygfx is a Python graphics library, based on
* wgpu-py, which is a Python wrapper of
* wgpu-native, which is a C-API exposing
* wgpu, a Rust implementation of WebGPU, based on
* Vulkan, Metal and DX12, which talk to
* your GPU hardware :)
