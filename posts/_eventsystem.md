# How to make apps schale

<!-- DATE: -->
<!-- TAGS: GUI -->
<!-- AUTHOR: Almar -->

I recently did a lot of thinking about how to make apps scale. In
particular, I wondered what features should an app framework have to
make it scale well. More particular, how is information stored, shared
and communicated between the different components of an app? This post
is sort of a summary of what I found.


## Context

The reason I was looking into these things is 
[Flexx](http:/github.com/zoofio/flexx). This is a project that I have
been working on for quite a while. It's been in an alpha status for a
while, and I was working towards a new release that would bring it into
beta, when signals emerged from different directions that Flexx apps
became harder to manage when they grew in complexity.


## MVC

A classic pattern by which applications have been developed for many years
is the Model-View-Controller pattern. It is a way of writing your app in a
way that separates concerns; the *model* component deals with the application
code, the things that make the app do what its supposed to do, like
provided access to data, do things to the data, store the data, etc. This
is sometimes called "business logic" (but I don't like that term). The
*view* component of your application is responsible for displaying
something to the user, and listening to user interaction (e.g. mouse
events). The *controller* component hooks the model and view together. It's
a bit more fuzzy, because sometimes "controller code" is part of the
model or view, but it helps to think about it in this way.

The MVC pattern proved very powerful in the era when web pages were generated
on the server and statically displayed at the client (ah, the good old days!).
The model resides on the server, and takes the form of a database and the code
to query/set data from it. The view is the HTML (template), and the
controller is the code that takes an HTTP request, calls into the model
to have the desired effect, and serves up a new page as a result.

When JavaScript become more powerful, more of the "application logic"
was moved to the frontend (i.e. the browser). The server played a less
important role, and the MVC pattern was moved to the client as a whole.
That's when [things started to go bad](http://www.christianalfoni.com/articles/2015_08_02_Why-we-are-doing-MVC-and-FLUX-wrong).
The separation between the view and model became less clear, and the role
of the controller more blurry. Since everything lives in JavaScript, it is
easy for the view to have direct access to the model. And vice versa. It also
becomes tempting to store application state in the view (e.g. the state
of a check button directly representing a certain application-level
boolean).

In other words, moving everything to the browser made it easy to connect
things up, but this causes "spagetti code" as applications grow, making
them difficult (and painful) to maintain. The majority of current
solutions to make application scale better are aimed at *restricting*
the flow of inrformation in certain ways, to make it more predictable,
and therefore easier to understand the working of an app, even when its large.


## What is state

It's good to think for a moment what "state" is. State is the information that
defines the current "situation" of an application. Usually this is represented
as a set of properties/attributes of objects that make up the app.

One should distinguisgh between *application state* and *view state*.
The former represents the state of the model, and is "what matters".
The latter is comprised of the state of the check boxes, sliders, etc.
Ideally, the application state is leading and the view follows; setting the
application state to a certain value should have the same net result.
This keeps things predictable, and can help in debugging (e.g. you could
undo a certain state change).

(In practice, there are many gray areas, and sometimes practicality
beats purity, but its good to keep this separation in mind, and apply
it more strictly as your app grows.)


## Single store

When MVC moved to the frontend, the "state" that was usually represented as a
single database was now often spread out over multiple model objects, making an
app harder to understand.

One approach that many solutions use is to bring the application logic back
together into a single place, often called a *store*. This then becomes
a central component that provides the high-level functionality of an
app, and the views do little more than reacting to changes in its
attributes/state, and invoke certain functionality that the store provides.


## Direct versus indirect reactions to state

One important aspect that makes (modern) application frameworks scale
bad lies in the way how different components react to each-other's
state. It's a very flexible mechanism that different components respond to
each-other, so that changes in state propagate though an application,
each component fulfilling a certain responsibility. Except that the graph of
how objects relate to (depend on) eachother becomes very complex. This is
clearly explained in this [video about Flu][(https://youtu.be/nYkdrAPrdcw?t=10m25s).

There are two ways by which components can react to each-other; directly
or indirectly. In the first form, if a property of object A changes,
object B might immediately react, e.g. by setting other properties.
It's easy to see how that can be problematic:
```py
obj_a.foo = 42
# other objects can respond, change state anywhere, e.g. obj_c.bar can change
# things break down completely if there is a circular dependency.
do_something(obj_c.bar)
```

When writing Flexx, I fortunately realized this, and made Flexx process
the reactions in the next event loop iteraction. In other words, *indirectly*.
However, this makes it harder to track the cause of a certain reaction, and
the order in which reactions are processed is not well defined, because
the reaction is queued on top of the event queue, and wont be processed until
several other events are processed.


## The Elm architecture (Flux, Redux, Vuex)




## References

* http://www.christianalfoni.com/articles/2015_08_02_Why-we-are-doing-MVC-and-FLUX-wrong
* https://youtu.be/nYkdrAPrdcw?t=10m25s
