# Using LogSeq to make notes and organize my thoughts

<!-- DATE: 2023-01-02 -->
<!-- TAGS: gtd -->
<!-- AUTHOR: Almar -->

I've been trying LogSeq for organizing my notes and thoughts for a few months.
I'm blown away and am now moving my previous notes into the system.

<!-- END_SUMMARY -->

<img alt='An example LogSeq graph' src='images/logseq.png' width='700px' />
<br />

----

## Introduction

[LogSeq](https://logseq.com/) is a knowledge base that works on top of
local plain-text Markdown. It's an application where you can write and
organize notes. In particular, it has extensive support to *link* notes
together, as well as searching for (related) notes. This makes
navigating the notes a very smooth experience. People sometimes call
this "your second brain".

And it's open source!


## Related tools

LogSeq is part of a family of tools that try to help you
organize your thoughts. The idea is that while you may know a great
deal of facts and have a great deal of ideas, it's when you start to
see the links between them, that you get new insights that are truly interesting. These are the insights that lead to new research areas, business ideas, points for self-improvements, etc.

[Obsidian](https://obsidian.md/) is another similar tool, and is also
open source. I tried this before I got into Logseq, and it is what
got me interested in tools like this. I liked Obsidian a lot, but eventually
decided on LogSeq because it feels a bit more polished and plug-n-play.


Other similar tools include Joplin, Notion, and Roam. I don't have any
experience in these, so I won't comment on them.


## LogSeq vs Obsidian

In Obsidian, documents feel more like a regular document, whereas in
LogSeq everything is a bullet point, which they call them blocks. This feels
a bit odd at first (it did to me at least), but once you get used to
it, you'll recognize its power. Blocks represent a unit text (that can
have sub-blocks), that are easy to move around, can be referred to, and
are listed as a unit in e.g. search results and back references.

LogSeq has a builtin journal, which looks like a single document with one section per day.
This is where you can write daily notes, fleeting thoughts, quick todo list, meeting notes, etc.
Together with how blocks work, this allows for a very intuitive journaling process.
Similar things are possible in Obsidian, but you'd have to set it up yourself in some way.

Both LogSeq and Obsidian have a wide range of plugins. Obsidian has far more
plugins and seems to have a more active community in this respect.

Both Obsidian and LogSeq have a graph view, though Obsidian's is the much-praised winner on this front.

Obsidian has a distinction between links and tags, allowing for flexible
ways of organizing stuff ... that also confuses me at times. In LogSeq tags are
simply links.

I think it'd be fair to say that Obsidian is more hackable and easier
to tweak for specialized workflows, while LogSeq tries to provide a
smooth yet generic workflow out of the box.



## Workflows

In an [earlier post](/getting_things_done.html) I talk about my journey
through using different note taking apps. I've gone from a home-made
app, to Trello, and back to the home made app. I've also spent months using
paper and pen for most note taking and task management. Let's see how
I now fit my different workflows into LogSeq ...


### Notes

I make notes in the journal. For meeting notes this makes perfect sense. Smaller notes exist as separate blocks
in the journal, marked with tags. Larger notes I sometimes put into
their own page, and then link to them from the journal.


### Ideas

I write ideas simply as blocks in the journal, tagged with ``#idea``. When I
go to the page for "idea", the *Linked References* section shows all
ideas in chronological order; a spark file, just like that!


### Larger texts

Previously, I sometimes wrote larger pieces of text on certain topics,
either in Google docs or as markdown files stored on my computer. I now
imported these into LogSeq and added some tags to them. Now they are fully part
of my "digital garden" and I can link to them from other notes.


### Task management

LogSeq has a simple system to create tasks and mark them as done. Tasks can
also be scheduled for a certain date, and even support recurring tasks. There is also a plugin to make this system
more powerful.

I tried this for a few months to do my task management, but stopped using it, because
it feels a bit awkward/fragile to me. I came to the conclusion that LogSeq is primarily a tool to organise your
knowledge and ideas. While this affects the tasks that you set for
yourself, it is not the best tool to do the actual task management.
Tools like e.g. TodoIst are much more streamlined for that.

I do still use LogSeq's `TODO` mechanism, but only for lists in a specific block.
