# New task: don't forget to organize your ideas and knowledge too!

<!-- DATE: 2014-11-19 -->
<!-- TAGS: gtd -->
<!-- AUTHOR: Almar -->

Like many people, I use todo lists to organize my tasks. I’ve tried
different todo-list solutions and even made a few apps myself. In this
post I try to explain what I learned from these tools, why organizing
knowledge and ideas may be more important than organizing tasks, and
why I like [Trello](http://trello.com) so much.

<!-- END_SUMMARY -->

![The Arctic Council planning a search for Sir John Franklin](images/search_for_Sir_John_Franklin.jpg)
<br /><small><i>
Image by Stephen Pearce (public domain)
</i></small>
----

## Organizing knowledge

Some tasks assigned to you originate from someone else. But (I hope)
that there are also many tasks that originate from yourself. Where do
tasks come from in that case? Most tasks are part of a bigger plan,
which was in its turn formed from ideas, ideals, and a certain purpose.

Managing tasks is only one side of the medal. You may be very efficient
in executing your tasks, but if you neglect the origin - your goals
and ideals - you live an empty life.

I believe everyone has a purpose, and in essence this purpose is to make
yourself useful, by doing something that you love doing. And the main
goal in life, as I see it, is to find that purpose.

Starting with a purpose, you develop ideas, and by combining ideas you
create plans, which in turn lead to concrete tasks towards achieving
your goals. Organizing your knowledge, ideas and plans can help you
during this process of creation.

## Tools to manage stuff


### The common todo list

Many todo lists are a simple one-dimensional lists of tasks. In many cases
this suffices.
I used to kept track of tasks using a text file (in my dropbox folder
for easy access). I've also tried
[Google tasks](https://www.gmail.com/mail/help/tasks/),
[Remember the milk](https://www.rememberthemilk.com/),
[Evernote](https://evernote.com/), and others.

Although most implementations allow keeping track of multiple lists, this
approach provides little means to *structure* tasks and set priorities.
I do think common todo lists can be useful. But the most useful
variant is often just a piece of paper to write down the things planned
for this day or week.


### Priority vs importance

![my Eisenhower-inspired task app](images/screen_gtasks2d.png)

When I learned about it, I liked the distinction between priority and
importance that is promoted by the
[Eisenhower matrix](http://en.wikipedia.org/wiki/Time_management#The_Eisenhower_Method).
I liked how this method uses two dimensions to structure tasks.
Therefore I made a small Python+Qt application based on this idea. It
uses Google tasks as a back-end, so that tasks can be managed from
anywhere. All tasks sit on a 2D canvas. The more to the right, the more
urgent it is, the more to the top, the more important it is.
It did give a nice overview of tasks, but while using it, it quickly
became cluttered with tasks, and at some point I needed to move tasks
around to prevent them from overlapping. I thought about filtering tasks
based on tags, but this method just did not seem to scale up very well.

This was also when I started to realize that what I wanted was to
organize my *thoughts*, of which organizing tasks is just one aspect.
I wanted to keep notes and a
[spark file](https://medium.com/the-writers-room/8d6e7df7ae58)).
These do not really fit in an Eisenhower matrix,


### Filter, don't sort

![my filter-based task app](images/screen_notes.png)

The next app I made was inspired by [todo.txt](http://todotxt.com/). I wanted
to keep it simple and always accessible. Therefore the app stored the data
in a text file stored in my Dropbox folder.
It uses a simple [protocol](https://bitbucket.org/almarklein/notes)
that is human readable. By default, the app shows all
items in chronological order. By writing a tagname in the search field,
the app will show only tasks marked with this tag. The same search field
allows plain-text searching through my all notes/tasks/ideas, or
selecting only tasks or ideas.

This solution has worked quite well for me for a year or so, until I
learned about something better ...

*edit (June 2017): After hardly using Trello for almost 2 years, I've revived this little app again, and use it almost daily*

*edit (Januari 2023): I've now [become a fan of LogSeq](/logseq.html).*

### Hello Trello!

![Trello web app](images/screen_trello.png)

I've been using [Trello](http://trello.com), for a while now and
absolutely love it. Trello is brilliant in its simplicity; it offers
simple tools to organize basically anything you want. This is at the
same time its biggest pitfall, because you have to think about how you
are going to organize things. In fact, I had tried Trello before, but
then thought that it did not meet my needs. Only when I read about it
again and tried it more seriously, I realized its true power.

With Trello, you can organize information in four levels:

* The user or **organization** (multiple people can be part of an
organization).
* Each user (or organization) can have multiple **boards**. Only one board
is shown at a time. Many things like access rights are also managed
on the board level.
* Each board has **lists**, which are organized horizontally. You can
  move lists around by dragging their title.
* Each list contains (vertically stacked) **cards**. Again you can
move cards around (also to other lists) by dragging.
The card is the unit element in Trello. By clicking on a card you see
the "back" of the card, where you can write details, create checklists,
set due dates, have discussions, attach files and assign people.

For myself, Trello is in many ways what I was looking for:

* It uses the horizontal dimension very effectively for providing structure.
* It's flexible enough to structure tasks as you like.
* It can help you organize not only tasks, but also thoughts/ideas/notes/etc.
* You can easily share boards with other people.
* It has a restful API (which I thankfully used to inject all
my existing tasks, notes and ideas). Also it prevents lock-in.
* It has a really good smartphone app.
* It's free.


## How to use Trello

Trello can be used in many different ways. You'll have to experiment to
find out what works for you. Fortunately it is easy and intuitive
to move things around. Here are some ideas:

* By default, a board has three lists: "todo", "doing", "done". This provide
a good starting poing for many projects.
* I have a board for general tasks where I have a list for stuff that
I should someday do, a list for things that need attention soon,
and a list for things that are urgent.
* In the image above you see the Trello board that I use to "plan" my
blog. On the left is a list of ideas. Stuff that touches me or I think is
important. At some point I turn one or more of these ideas into a plan for
a blog post, which I start writing: I move the card to the second
list. When done and published, I move the card to the final column.
* People use it for SCRUM development: each card is an issue. Developers
are assigned to the issue and the issues travels from one list to another
as it get different states (e.g. in progress, fixed, under review, verified).
* Sometimes a board represents a project. Sometimes it may be a way to
organize knowledge. Or a means to communicate with customers.

For more example see e.g.
[this post](http://blog.trello.com/trello-is-now-trello-inc/).
Above all, I encourage you to just try it. Create lists and cards, don't
be afraid to move things around to search for a better structure.


## Conclusion

Organizing your tasks is great to be productive, but it's equally
important to organize your knowledge and ideas, so that you are being
productive in the right direction. For short-term stuff I still prefer
pencil and paper. But for everything else, I think Trello does a really
good job.
