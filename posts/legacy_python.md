# Write Python 3, while supporting Python 2.7

<!-- DATE: 2016-02-12 -->
<!-- TAGS: python, legacy, flexx -->
<!-- AUTHOR: Almar -->

In this post I discuss an approach for writing code in Python 3,
and still support Python 2.7. I've recently used this approach in one
of my own projects. Most projects should get away with only minor
modifications and an automatic translation step during package-build.
However, there are some pitfalls (bytes/str) that might need special
attention.

<!-- END_SUMMARY -->

I've always been a proponent of Python 3, and I have been bashing Python 2
(a.k.a. legacy Python) at many opportunities. To be fair, Python 3 was 
[announced](https://www.youtube.com/watch?v=sUm876SoUPM) just a few months
after I started using Python, so I did not have much existing code that
was holding me back. In fact I started writing Python 3 wherever the
dependencies allowed it, and indeed [the Pyzo IDE](http://pyzo.org) 
was written in Python 3 (almost) from the start. For most other
projects, though, I have written code that runs on both Python 3 and
Python 2.


![Silly walks grafity](images/sillywalksgrafity.jpg)
<br /><small><i>
Image by southtyrolean (CC BY 2.0)
</i></small>


## Supporting both Python 3 and Python 2

Initially, most projects started supporting Python 3 by making use of the
`2to3` tool, which translates the code (to make it compatible with
Python 3) during the installation. In other words, developers were
still writing in Python 2, but put some effort to support "early
adopters" of Python 3.

An approach that is increasingly popular is to write code that runs on both
Python 2 and 3 without the need for a translation step. Tools to help with this
are (amongst others) [six.py](https://pypi.python.org/pypi/six) and
[python-future](http://python-future.org/).

I have been following this approach for several years. It's not even
that hard if you know what to watch out for. However, I am increasingly
annoyed by this approach, and I feel a great sense of satisfaction when
I write code for Python 3 only, when I can just write `super()` and
don't have to worry about `isinstance(x, basestring)`, etc.

Therefore, I think we should move to an approach of writing Python 3,
and support legacy Python (i.e. Python 2.7) where needed by making use
of an automated translation step at build time. It does not seem like
there are currently many projects that follow this approach, but my
guess is that we will be seeing this more, because Python 2 is going to
be depreciated by 2020.


## Why support Python 2

Python 3 is obviously the future, and as a community we should try to
get rid of Python 2. By supporting legacy Python, we are holding back
progres, because we can not always make use of certain features (e.g.
`super()` or the matrix multiplication operator).

Making new (and useful) packages only available in Python 3 can be an
effective incentive for users to transition to Python 3, and thereby speeding
up the transition process of the scientific Python community.

At the same time, however, not supporting legacy Python can hold back the
adoption of a project, and there may be social reasons, e.g. an important
cliet still relies on Python 2. I don't think I would care working on
supporting legacy Python in unpaid time though...


## My experience

I have been writing the [Flexx project](http://flexx.readthedocs.org)
in Python 3 from the start. The project contains a few quite interesting
pieces, such as PyScript, a Python to JavaScript transpiler. We have
been adopting this transpiler in the [Bokeh project](http://bokeh.pydata.org)
to allow users to write client-side callbacks in Python. The initial
approach (that I've been advocating) was to only support this functionality
on Python 3, and look at Python 2 in case there was demand. As Bryan
Van de Ven anticipated, one of the first user questions were about when this
functionality would be available in Python 2. 

We agreed to make Flexx available in Python 2.7, but I did not want to
sprinkle the code with references to `basestring` or snippets from
`six.py`, so I set out to look at the approach to translate the code
at build time.

Some googling did not reveal many projects following this
approach (yet), but I did find a library called `lib3to2`, which more
or less promised to do what I needed. I was not quite happy
with some of the translations though (especially the handling of `bytes`
and `str`), and I found it quite slow. While the `lib3to2` library
supports Python 2.6 and even 2.5, I am only interested in 2.7, which means
some things could be done much simpler.


## The translate_to_legacy module

I decided to write my own
[translater module](https://github.com/almarklein/translate_to_legacy), 
that uses a tokenizer instead of a full AST parser. This means higher
speed and much simpler code, for a less detailed description of the
code, but it proved enough to do all the translations that I wanted
to do.

I decided to only target Python 2.7, which means that much less
translations are necessary. For instance, you can just keep `b'xx'`,
and there is a `bytes` class as an alias for `str`.

A brief overview of the applied translations:

* futures: at the top of each file `from __future__ import ...` was added, for
  'print_function', 'absolute_import', 'with_statement',
  'unicode_literals', and 'division'. The 'unicode_literals' means that
  all string literals are unicode, so no need to add a "u" in front
  of any strings.
* cancel: if the code already contains `from __future__ import ...` with
  any of the above names, it is assumed that the code is already made to
  be compatible for Python 2 and 3. No translation is performed.
* newstyle: classes that do not inherit from a base class, are made to
  inherit from `object`.
* super: use of `super()` is translated to `super(Cls, self)`.
* unicode: translate `chr()` and `str()` to their unicode equivalents, and
  `isinstance(x, str)` is translated to `isinstance(x, basestring)`.
* range: translated to `xrange()`.
* encode: `.encode()` and `.decode()` are translated to
  `.encode('utf-8')` and `.decode('utf-8')`.
* getcwd: `os.getcwd()` is translated to `os.getcwdu()`
* imports: simple import translations.
* imports2: advanced import translation (e.g. `urllib.request.urlopen` ->
  `urllib2.urlopen`). In contrast to `lib3to2`, we only translate imports,
  not the use of imported variable names.

With these translations, and only minor tweaks to the code, things were
looking good.


## The loose ends

There are however, a few situations that need special attention. Most
notably places that use `isinstance(x, bytes)`. I used this in one
spot to determine whether a filename or actual data was provided. But
on legacy Python a `str` is the same as `bytes`, so it would work
incorrectly. In this case I wrote a little function to check whether
the given input looked like a filename or not (e.g. no zero bytes and
no newlines). It's not 100% bulletproof, but good enough. (On Python3
it obviously still just checks whether the input is `bytes`.)

Another situation that needs special attention is the creation of
metaclasses, e.g. `type('MyName', bases, {})`. On Python 2, the name cannot
be unicode. Together with the 'unicode_literals', this causes problems.
It's easily resolved, but it takes a few extra lines of code.

Likewise, setting environment variables must be done with `str` objects, and
not `unicode` in Python 2. 


## Using this approach in your projects

To adopt this approach in another project you need to:
  
* add [one module](https://github.com/almarklein/translate_to_legacy/blob/master/translate_to_legacy.py)
  to the root of your project.
* in `setup.py`
  [invoke the translation](https://github.com/zoofIO/flexx/blob/v0.3/setup.py#L54-L69)
  at build time.
* in the root `__init__.py` add 
  [two lines](https://github.com/zoofIO/flexx/blob/v0.3/flexx/__init__.py#L32-L33)
  to make legacy Python use the translated code.
* optionally add more translations by subclassing `LegacyPythonTranslator`.

You might need to make a few small modification to make the translations
work correctly, or resolve tricky situations like `isinstance(x, bytes)`.

Note that the code is still a single-source distribution, so if your code
is pure Python, you can e.g. still build universal wheels, or noarch
conda packages.


## Summary

If you want to write in Python 3, but still support legacy Python, using
a translation step at build time seems like a viable solution.
If you limit legacy support to Python 2.7, the number of required
translations is certainly feasible, though you may have to make small
adjustments to your code, e.g. to make any import translations work
appropriately. Further, be aware where `bytes` are used explicitly.

Other than that, you can just write in Python 3! Well, mostly anyway,
some features like function annotations, `async` and matrix multiplication
cannot be translated. But no worries, by 2020 we can forget about Python 2
once and for all!
