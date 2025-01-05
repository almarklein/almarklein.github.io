# The thee language problem, and how Web Assembly will help solve it

<!-- DATE: 2017-06-21 -->
<!-- TAGS: langs, python, julia, wasm -->
<!-- AUTHOR: Almar -->

Historically, languages are either easy to use *or* fast. Julia has
shown us that we can have both. I argue that in this day and age, we
may *also* aspire a language to run on the web and mobile devices. I'll
explain how I think that Web Assembly will bring us closer to this goal.


<!-- END_SUMMARY -->

![turtoise and rabit](images/turtoise_and_rabit.jpg)
<br /><small><i>
Image from "St. Nicholas" (no known restrictions), via Flickr
</i></small>

----

## The two language problem
 
The programmer John Ousterhout [stated in 1998](https://en.wikipedia.org/wiki/Ousterhout%27s_dichotomy)
that high-level programming languages tend to fall into two groups, one being fast
but hard to write, and one being easy, but slow.
 
Ousterhout meant this as a way of saying "use the right tool for the job", but
this idea has also become known as *the two language problem*. The point is that
programmers, especially in science and engineering, write their initial code
in an "easy language", because they [need its dynamic nature](why_dynamic.html)
and abstractions; the problems they work on are hard enough already.
When such code is to be used in real applications, it will often have to be re-written
in a language that is faster (and perhaps more robust).
 
 
## Consequences
 
Having to rewrite code in another (harder to use) language complicates things a lot,
because the people who wrote the original code are often not capable of writing
in another language, and the people who are, do not always sufficiently understand
the problem that the code solves.
 
I believe that this effect is a significant inhibiting factor in turning
scientific innovation into real world solutions. At university I've
seen countless times how research is done, the (PhD) student finishes,
and the research code is never touched again.
 
This problem has been one of the reasons why I moved from Matlab to Python. In this
case it was not so much about speed, but about the fact that Matlab is terrible
for building GUI applications and equally bad at distributing them (caused in part
by its proprietary license model). In Python I can write code, build a
GUI around it, freeze the app, and put it online for anyone to use.
 
 
## The three language problem
 
A decade ago, the internet played a role in *distributing* apps, but (except for
a few annoying applets and Flash) apps were all desktop apps. With JavaScript
becoming much faster and better standardization (e.g. HTML5), things have changed a lot,
and the browser is now a common platform for *running* apps. For scientists,
this provides an opportunity to [publish results](future_vis.html) and ideas in
interactive ways. If you can write JavaScript, that is. (Or CoffeeScript,
or TypeScript, or Elm; JavaScript kinda sucks, and many things have
been made to make it suck a bit less.)
 
We're at a point where many people use their phone more than their
laptop/desktop. Mobile apps are typically written in Java or C++, or
Swift for iOS. You could thus argue that we have a four or five language
problem. On the other hand, mobile apps can be created using web
technology too. So for the sake of argument, we'll stick to "the three language problem".
 
Summarizing, the three language problem states that we generally need one language for
each of the following tasks:
 
* Writing code easily, allowing an easy start for newcomers, quick development, and solving complex problems;
* Writing code that runs fast;
* Writing code that runs in the browser and mobile devices (i.e. is "safe").
 
Granted, when Python was just being
created, it was hard to anticipate that web browsers would become such
an important platform to run apps on, nor that mobile devices would
become so ubiquitous. Similarly, we cannot anticipate what the digital world
will look like 20 years from now, and what N language
problems we will have then. But let's focus on solutions for today's problems.
 
 
## Partial solutions
 
The [Julia language](https://julialang.org/) has shown that a dynamic language can
also be fast (on par with C). However, I share the view of [Greg
Wilson](https://software-carpentry.org/blog/2015/06/why-i-am-not-excited-about-julia.html)
that Julia is not as easy as it could be. I'm also sceptical about Julia's ability to run
in the browser. Julia leans quite heavily on C++, and its (scientific-oriented) standard library
is pretty big, dependending on several Fortran libraries, including code that embeds
machine instructions. This means that bringing Julia to the browser is not trivial and
likely results in large (i.e. slow to load) libraries. There are
[discussions](https://github.com/JuliaLang/julia/issues/5155) in the
Github issue tracker though, about defining a smaller base library and/or
a "Julia lite".
 
In Python, many solutions are available for writing faster code, most notably
[Cython](http://cython.org/) and [Numba](http://numba.pydata.org/). These projects
are amazing, allowing Python developers (including myself) to write code in a familiar style and
have it run fast too. However, in the greater scheme of things, these
feel like patches to overcome a fundamental limitation of Python.
 
I'm also [trying](http://flexx.readthedocs.io/)
to make it easier to write code that targets the web in Python. And although we've
been building great things with this approach, it’s far from perfect.
 
----
 
## Enter Web Assembly
 
Lately, I've been [looking into](https://github.com/almarklein/pywasm) Web Assembly (WASM).
 
[WASM](http://webassembly.org) is a new open standard developed by representatives from all major browsers. It is a low level binary format designed to be compact and run at native speed, while being memory-safe. WASM is primarily intended to run code in browsers, but will also run in [other environments](http://webassembly.org/docs/non-web/) like desktop, mobile and more.
 
WASM's features make it an attractive intermediate
representation (or "platform"), also beyond the browser. For instance,
it's designed to be inherently "safe" (code being run is guaranteed to
not do things that it’s not supposed to), which is also great for mobile
apps. There are already solutions for running WASM on desktop, and I'd
not be surprised if someday there'll be a microprocessor that consumes
WASM directly.
 
 
## How WASM will help
 
WASM can help relieve the three language problem in various ways. For instance, Python libraries can use it as a tool to make certain code run fast, similar to how Numba uses LLVM. I’m not sure how WASM compares to LLVM for this use-case, but I can imagine that WASM might be easier to target.
 
Similarly, certain Python tools could produce WASM to run specific code on the web. Python interpreters intended for the browser (like [Skulpt](http://www.skulpt.org/) and [Brython](https://www.brython.info/)) could make use of WASM to become (much) faster and more compact.
 
And, of course, what WASM is intended for, to compile C/C++/Rust programs to a format that can run in the browser. A similar approach can be used for Julia, although (as mentioned above) this is not trivial.
 
 
## Dreaming out loud
 
The approaches mentioned above will provide many opportunities, but what if WASM is targeted more directly?
People have been dreaming of "one language to rule them all". Some say
[Julia is it](https://www.wired.com/2014/02/julia/) is it. Others say
[JavaScript](https://medium.com/@teerasej/javascript-one-programming-language-to-rule-them-all-5d10079068da), which is a thought gives me the shivers.
 
I don't believe that there will ever be a language that is *the best* in
all fields.
But I can't help thinking ... what if there was a language that is designed to be easy to use,
dynamic and fast like Julia, *and* run anywhere?
Such language might be *great* for almost every field. And in my view, the best
chance of such a language right now, is one that directly targets WASM.
 
 
## Disclaimer
 
Don't take any of the above as critique on any of the mentioned
projects. This post is written from a high-level (idealistic, perhaps
a wee bit naive) perspective. I know that creating a new language is
much more than inventing syntax and writing a compiler; communities and
package ecosystems take many years to build. But a man can dream!
