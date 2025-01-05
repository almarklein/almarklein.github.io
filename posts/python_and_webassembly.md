# Python and WebAssembly


<!-- DATE: 2018-12-02 -->
<!-- TAGS: langs, python, wasm -->
<!-- AUTHOR: Almar -->

Despite its name, WebAssembly is not limited to the browser. In fact,
it's potential outside of the browser is at least as interesting. In
this post I talk about some experimental work that we have done in
combining WebAssembly with Python.


<!-- END_SUMMARY -->

<img src="images/pano_ed.jpg" width="100%" />
<br /><small><i>
Edinburgh - Image by Almar Klein (CC BY 4.0)
</i></small>



## Introduction

In my <a href='n_language_problem.html'>previous post</a>, I argue that WebAssembly
would be a very interesting target for (new) programming languages that are intended
to run fast, and run "anywhere". Not long after that publication I gave a
[talk at EuroScipy 2017](https://www.youtube.com/watch?v=KOC9EOQyU0k) about WebAssembly.
At the same conference,
[Windel Bouwman](https://github.com/windelbouwman/) gave a talk about his
[PPCI project](https://bitbucket.org/windel/ppci): a compiler infrastructure
written in Python. The two of us teamed up, and in the train on the way back
we managed to create a prototype in which Python consumed WebAssembly
code and ran it.

In the months that followed, we've continued working on it, and this culminated in
a [talk at EuroPython 2018](https://www.youtube.com/watch?v=u2kKxmb9BWs), in which
we show what we had achieved. In this post I dive into some of the details.


## WebAssembly is not only for the web!

Although WebAssembly is primarily designed for the web, its use outside of the
web has been [taken into account](https://webassembly.org/docs/non-web/) from the beginning.
And it has great potential there ...

For one, WebAssembly is a well-designed open standard for fast executable code.
Let this simple fact sink in; once we have good WebAssembly runtimes on all major
operating systems, we can build true cross-platform binaries! I also don't expect it to
take long before mobile devices natively support WebAssembly.

Since WebAssembly is well-defined and makes few assumptions about
the underlying hardware, it is excellent for taking on the role of an
intermediate representation (IR). For instance, compile language X to
WebAssembly, and then compile the WebAssemby to machine code for an
embedded device (e.g. Xtensa).

Further, every WebAssembly module very clearly specifies what it needs,
and only *gets* what it needs when the host environment provides it.
This means that users can potentially have a lot of control and insight
into what an application can do on your system. This feature is critical
in the browser, but about as important on mobile (i.e. app permissions),
and actually, isn't it odd that we don't have this on desktop too?


## How can Python use WebAssembly?

For most compiled languages (e.g. Rust) the advantage of adopting WebAssembly
is pretty simple: compile to WebAssembly instead of the normal compile target,
and now you can run it in a browser.

Python is not a compiled language, which means that things are not so straightforward.
But this does not mean that the Python community cannot make use of WebAssembly.
I will discuss three potential uses below.


## Compile a Python interpreter

One of the more obvious use-cases is to take a Python interpreter, compile it
to WebAssembly, and voila, you have a Python interpreter in the browser!

This has several interesting and useful use-cases. But would I use this approach to create a web application?
Probably not; the WebAssembly code that needs to be loaded (the Python runtime)
would be pretty big, and the code would not be faster than the original runtime.

Examples that use this approach:

* [Pyodide](https://github.com/iodide-project/pyodide) compiles CPython,
  Numpy and a few more scientific packages to WebAssembly to realize a
  scientific Python stack *in the browser*!
* [PypyJS](https://pypyjs.org/) Takes the PyPy interpreter and compiles
  it to WebAssembly (technically it uses ASM, say, the precursor of
  WebAssembly).
* [RustPython](https://github.com/RustPython/RustPython) (by Windel)
  is a new Python interpreter written in Rust. And since Rust has
  excellent tooling to compile to WebAssembly ...


## Compile a subset of Python

In PPCI we've created a
[compiler](https://bitbucket.org/windel/ppci/src/default/ppci/lang/python/python2wasm.py)
that statically compiles a subset of Python to WebAssembly. It is only
capable of compiling a very strict subset of Python. For instance, it assumes
that all objects are floating point numbers.
This approach could be improved, e.g. by supporting more types using Python's type hints.
However, the supported subset of Python will always be limited to something that
can be statically compiled.

Despite this restriction, an approach like this could be very useful to write
functions that can be used inside a web application.
Or ... to write code that runs at native speed. The example below shows
the resemblance with [Numba](http://numba.pydata.org/):


```py
@wasm.wasmify
def find_prime(nth):
    n = 0
    i = -1
    while n < nth:
        i = i + 1
        if i <= 1:
            continue  # nope
        elif i == 2:
            n = n + 1
        else:
            gotit = 1
            for j in range(2,  i//2+1):
                if i % j == 0:
                    gotit = 0
                    break
            if gotit == 1:
                n = n + 1
    return i
```

In the talk I [show a demo of this](https://www.youtube.com/watch?v=u2kKxmb9BWs&feature=youtu.be&t=739),
and yes, the code indeed runs much faster than plain Python!

It should be noted though, that the speed at which code like this can compile and run
is highly dependent on the WebAssembly compiler (the part that compiles
WebAssembly to native machine code). We're now doing this in pure Python with PPCI, which
makes the compilation slow, and it does not perform many optimizations.

In comparison, [Firefox does amazing things](https://hacks.mozilla.org/2018/01/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler/) to compile WebAssembly modules.
Maybe it's possible to leverage Mozilla's efforts and use its WebAssembly compiler on desktop, from Python?


## Python as a WebAssembly platform

WebAssembly is a modern standard and is very well designed overall. For example,
a WebAssembly module very explicitly defines its *imports* (the things
that it needs), and the *exports* (the things that it provides). It is up
to the host environment (e.g. JavaScript) to provide the imports and make use of
the exports.

In PPCI, we've created tooling to load binary WebAssembly modules and examine
their imports and exports. Using an API very similar to that of JavaScript,
we've made it possible to provide imports in the form of Python functions.
... yes, you can call back into Python functions from WebAssembly code that is running
natively!


In that way, it is possible to take multiple WebAssembly modules—which
can be created with any language—and bind them together in Python. This is what
Python has always been good at: binding things together.
But now the *things* are self-contained modules that can each be written in
another language.

<img src='images/rocketai.png' style='width:100%; max-width:600px' />

To illustrate this idea, we took the WebAssembly module of [the Rocket game](https://github.com/aochagavia/rocket_wasm). We did not read any docs, we just took the binary WebAssembly module and loaded
it into PPCI. We examined the *imports* and *exports* and that was all we
needed to write the supporting Python code to make the game work.

Next, we wrote an AI that is capable to play the game automatically. We wrote this
in C, which we compiled to WebAssembly. Now we had two WebAssembly modules,
which we bind together in Python to create a [complete system of an AI playing the
Rocket game :)](https://www.youtube.com/watch?v=u2kKxmb9BWs&feature=youtu.be&t=1296)


## Wrapping up

WebAssembly is coming and it's awesome. It definitely has its use on desktop too,
and there are several ways in which the Python community can make use of it!
