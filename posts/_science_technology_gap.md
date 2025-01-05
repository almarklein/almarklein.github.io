# The gap between science and technology


<!-- DATE: -->
<!-- TAGS: open source, science, engineering, python -->
<!-- AUTHOR: Almar -->

Often scientific research has great potential to improve our
world, but to turn this research into a real world application is often
difficult, because scientists and engineers often use different tools
and have differnt skill sets. In this post I argue that this can be
overcome by making more use of general purpose programming languages
and by teaching our scientists better programming skills.

I this post, I am talking about research that relies heavily on
software, such as (medical) imaging or data analysis of any kind.


<!-- END_SUMMARY -->


## Science and engineering

From wikipedia: 

* Science is a systematic enterprise that builds and organizes knowledge
  in the form of testable explanations and predictions about the
  universe.
  
* Engineering is the discipline, art, skill and profession of acquiring
  and applying scientific, mathematical, economic, social, and practical
  knowledge, in order to design and build structures, machines, devices,
  systems, materials and processes that safely realize improvements to
  the lives of people.

Henry Petroski once wrote: “Science is about understanding the origins,
nature, and behavior of the universe and all it contains; engineering
is about solving problems by rearranging the stuff of the world to make
new things. “

Strictly speaking, science has the goal of improving our understanding
about the universe. However, there is also a lot of science aimed at
solving rather particular problems, such as research to cancer or
material sciences. Often there is a point where the application of the
research becomes so specific and aimed at a particular goal, that it
starts to become more about engineering then about science. Where
science becomes engineering is subjective (and irrelevant for the rest
of this story).


## The gap

Of all the research done in academia, some falls in the category of
theoretical science, and does not have a purpose other than getting a
better understanding of the world. Quite a lot of research, however,
has the potential to be translated into technology that can benefit the
lives of people. However, transforming research into an application is
often not trivial, and the skills requires to do so are often different
from the skills required to do the research itself.

Researchers often use a development environment aimed at a particular
purpose (Matlab is one example). When a researcher has developed an
algorithm that has the potential to improve the lives of other people,
it can be decided to turn it into a product. Unfortunately, many
development environments that are used by researchers are not suitable
for making professional software applications.

This means there is a gap. A gap between science and technology. In
this gap can prevent potentially useful research to reach the general
public.


## Problems

The biggest problems that cause this gap are:

1) Scientists often use tools (i.e. programming languages) that are not
suited for making user applications. Such tools (like e.g. Matlab) may
be useful for scientific use, but are worthless when it comes to
building graphical user interfaces (GUI's) or deploying applications.
Deploying is the process of turning the application into something that
can run standalone at a users computer. Or to make the application
available as a web application that can be accessed via the browser.

2) Scientists often do not have the skills necessary to build user
applications. They are generally less used to writing unit tests, may
not be using version control, etc.

Consequently, when research is to be turned into a user application,
the software often will have to be rewritten in a different programming 
language. Apart from the fact that this is a lot of work, the software
engineer* who does this, may have a hard time following the complex
algorithms, and will probably need the help of the scientists in the
process.


## Bridging the gap

How aweseome would it be if research could be turned into a user
application with minimal ease!

This is possible if the environment in which the research code is
written is also very suitable for creating applications. In other words,
I think scientists should make more use of general purpose programming
languages.

Currently, Python is a very suitable choice in this respect. 
[Python](http://python.org) is a generic language with extensions for
many GUI toolkits. This makes it very suitable for creating professional
applications. Since Python is a [dynamic language](http://almarklein.org/why_dynamic.html), 
it is very suitable for developing algorithms. And since Python is easy
to read and is very powerful, developing complex algorithms is easier
than in most other languages.

Further, scientists should make make more use of modern software
engineering workflows like version control and unit testing.

Now this may seem like I am asking scientists to do more work. I am
not. The scientific Python stack is quite mature and provides tools
that are in many situations better than the "conventional" scientific
tools. The fact that the scientific Python community is growing fast
is says enough. Further, adopting version control and unit tests may
seem like a hurlde at first, but from my own experience this pays itself
back with ease.

Surely, there wil be scientists who rely on non-general purpose tools
because there simply is no alternative available. In that case you'd
have to go down the old route. Or ... you (and your colleages) could
build the necessary tools based on the Python stack.


## Conclusion

If scientists would make more use of general purpose programming
languages and good programming practices (such as version control),
their research would more easily reach the general public, and the world
would be a slightly better place.

In many cases the scientist would also be more effective in his/her
daily work due to the easier language and more effective workflow.
