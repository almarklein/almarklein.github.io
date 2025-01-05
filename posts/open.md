# The importance of open source software in science

<!-- DATE: 2014-07-30 -->
<!-- TAGS: oss, science -->
<!-- AUTHOR: Almar -->

For the first post in this blog I wanted to write something that really
matters. At least to me. I tried to get at the core drivers behind what
I do: what are the fundamental reasons why I love open source software
so much?

Here's why I think that open source is *necessary* to improve/fix the
current scientific system and to guarantee our freedom to seek knowledge.

<!-- END_SUMMARY -->

![Cat anatomy](images/catanatomy.jpg)
<br /><small><i>
Image by Internet Archive Book Images (no restrictions), via Wikimedia Commons
</i></small>

----

## Open source software is rising

When I started using Python in 2008, the scientific Python stack was
not very mature yet. So although I believed that Python was a great
tool for scientists, I did not feel that I could recommend it to my
colleagues or students yet.

Wow, a lot has changed since then! The development of the scientific
Python community is increasing fast, and with that the development of
the scientific packages. Many packages can be considered quite mature
now. We have also established the *Scipy stack*, a set of packages that is
considered the core of the Scipy ecosystem.

Right now, I would definitely recommend Python to anyone who wants to
do something related to scientific computing, imaging or data analysis ...

At the same time, other very interesting open source projects are being
developed that enrich the scientific ecosystem. For example, Julia is
a promising language that borrows ideas from Python and Matlab.


## Not only software

The rise of open source software is not an isolated occurrence. It goes
hand in hand with the increasing demand for open access publications
and open standards.
People start to realize that publications funded with public money should
not be used for monetary profit for a small group of people; stuff paid
for by the public should benefit the general public.


## Reproducibility of scientific results

A similar trend occurs for the reproducibility of scientific results.
Any scientific publication that talks of results that cannot be
reproduced by others is essentially worthless. The definition of science
is quite clear about that (from Wikipedia):

> Science is a systematic enterprise that builds and organizes knowledge
> in the form of testable explanations and predictions about the
> universe.

In order to make scientific results reproducible, you need (at least)
three things:

* The data on which the analysis was done should be publicly available
* The code to perform the analysis should be publicly available
* The tools necessary to run the code should be publicly available

Only if these three conditions are met, a scientific result can be
considered reproducible. Only then can others verify the results and
ensure there are no flaws in the analysis. And only then can we reliably
build further on top of these results.

Sadly, there are currently not many publications that meet these
criteria. But... now that powerful open source tools are available,
there are few technical limitations that prevent improvement in this
area. Further, the open source culture in which sharing of code and
knowledge is considered normal can also help solve this problem.


## Equality

Anyone should be able to participate in the scientific process. No
matter where you live. No matter your financial situation, scientific
results should be publicly and freely available. And the same goes for
the tools to produce such results.
If you are in a university, you may have access to tools and publications
via licenses that your university pays for. But many universities don't have
the financial capacity for this. And even if they were, one should not have
to rely on a university for this.


## Broadening the audience

Not so long ago, data analysis happened mostly in C and Fortran; one
needed to be an adept programmer in order to do data analysis. This has
changed with the coming of e.g. Python and (granted) Matlab.
Nevertheless, the art of scientific computing is still dominated by
hard-core coders.

With digital data becoming more ubiquitous, more (non computational)
scientists rely on the analysis of data to obtain results. Therefore,
there is a need to open up the art of scientific programming to a
(much) broader audience.

The bottom line is that we need to make it easier to get started:

* It must be easy to get Python & packages (Anaconda, Pyzo and WinPython
help here)
* It must be easy to do the programming itself (we need to further improve
IPtython, IEP, Spyder, etc. )
* It must be easier for newcomers to find their way around
  ([scipy.org](http://scipy.org) helps)
* Last, but not least, we must *educate* people to learn how to use these
tools

Things are improving in this area as well, but there is still a lot of
work to do.


## The freedom to seek knowledge

Let's take it one step further. I think it should be more common
(also in our everyday lives) to apply data science. Instead of just believing
what other people tell us, we should analyse the available data and
decide for ourselves what is true and what not. Whether this concerns
important scientific subjects or just practical everyday issues, it
will help us make *informed* decisions based on our own results.


## Summary

To improve our current scientific system, we need good open source
tools, and we need to make these tools easy enough for all scientists
to use; we need to make science more accessible.

But we also need a shift in culture. One in which openness is the norm
and in which we can and will verify the results of others. So that
rather than relying on second hand information, anyone can seek
knowledge for himself. Because you can only truly believe something when
you've seen it with your own eyes.


## Further reading

* Fernando Perez also speaks about the importance of open source in
science, e.g. in [this blog post](http://blog.fperez.org/2013/11/an-ambitious-experiment-in-data-science.html).

* Lorena Barba's recent [blog post](http://lorenabarba.com/blog/why-i-push-for-python/)
about teaching Python at the university.

* Cyrille rossant's [blog post](http://cyrille.rossant.net/why-using-python-for-scientific-computing/)
that lists additional reasons for using Python in science.


