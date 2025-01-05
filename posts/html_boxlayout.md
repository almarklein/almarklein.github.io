# Comparing methods for box-layout in HTML

<!-- DATE: 2015-04-02 -->
<!-- TAGS: web -->
<!-- AUTHOR: Almar -->

This post describes a small experiment that compares a few methods for
doing a box-layout in HTML. On a variety of browsers the result was
validated, and performance measured. The results show that the CSS
``display: flex`` method is the way to go.


<!-- END_SUMMARY -->

![Escher's impossible cube](images/impossible_cube.png)
<br /><small><i>
Image from Wikimida (CC BY-SA 3.0)
</i></small>

----


## About box-layout

The box-layout model is a concept in GUI design that allows one to stack
multiple elements either horizontally (HBox) or vertically (VBox). Each
element can have a flex value (a.k.a. stretch factor) of 0 or more. A
flex of 0 means that the element should assume its "natural size". A
higher value indicates that it can assume a larger size; remaining space
is distributed among the elements by ratio of the flex values.

This model is a very common tool to layout widgets in an application
(e.g. Qt's [QHBoxLayout](http://doc.qt.io/qt-4.8/qhboxlayout.html)).
However, HTML does not have a trivial way to achieve such a layout;
there are multiple possible solutions. This post tries to explore which
one is best.


## Natural size

As mentioned above, each element will scale to its natural size or
larger. The natural size is determined by the content of the element.
E.g. for a button, it is the text on the button. But it also depends
on any children of the element (which could represent another box
layout). Solving this is complex.

A particularly problematic issue is that *in JavaScript there is no way
to measure the natural size of the HTML elements*. Internally, the
browser has information on the natural size  of all elements, but it's
impossible to access this information from JavaScript. Therefore, one
wants to take natural size into account, needs to rely on "native"
HTML+CSS methods to achieve layout.


## The methods

Below is a description of the three methods that were tested. For each
method two examples are provided: one simple version in the form of one
hbox with 3 elements, and one more complex version that consists of an
hbox with two vboxes that each have 4 hboxes with 3 elements. The latter
is thus an example of deep nesting as one might find in more complex
user interfaces.


### HTML Table

In the old days, a table was used for many layout tasks, because it
was all there was. This method essentially comes down to putting the
elements inside a table like so:
    
    <!-- HBox implementation using a table element -->
    <table> <tr> 
    <td> ELEMENT1 </td> <td> ELEMENT2 </td> <td> ELEMENT3 </td>
    </tr></table>

One advantage is that the table can already do much of the layout,
especially for the horizontal direction. In the vertical direction it
needs some help from JavaScript when resizing.

The implementation used here is based on an earlier version of a UI
project that I'm working on. It uses buttons for elements, which is why
it looks a bit different from the other methods. But it's the layout
that matters. Also I did not add images to the layout here.

Links:
<a href='html/boxdemo_table1.html' target='new'>Simple table layout</a>,
<a href='html/boxdemo_table2.html' target='new'>Nested table layout</a>

### CSS Box

In 2009, the CSS `display: box` model was defined. This is probably the
most common method found on the web used for box-layout. However, it’s
more or less deprecated. To get this working, it is important to use
all the `-moz`, `-webkit` CSS prefixes (see the source of the linked pages).

Links:
<a href='html/boxdemo_box1.html' target='new'>Simple box layout</a>,
<a href='html/boxdemo_box2.html' target='new'>Nested box layout</a>

### CSS Flex

The CSS `display: flex` model is like next generation of `display: box`.
It is the latest iteration of the [flexbox
model](http://www.w3.org/TR/css-flexbox-1/), and should presumable
become *the way* to achieve box-layout in HTML. However, at the time
of writing it is still in draft.
To get this working, it is important to use all the `-moz`, `-ms`,
`-webkit` CSS prefixes.

Links:
<a href='html/boxdemo_flex1.html' target='new'>Simple flex layout</a>,
<a href='html/boxdemo_flex2.html' target='new'>Nested flex layout</a>

## Results

The tests were loaded in several different browsers and machines. Between
the big three (FireFox, Chrome and IE) some FPS measurements were taken.
These were taken on two machines: a modern Windows laptop, and a relatively old
laptop running Linux (thus no IE measurement).

<style>
table.boxresults {
    text-align: center;
    padding: 10px;
}
table.boxresults td {
    border: 1px solid #999;
    border-width: 0px 1px 0px 0px;
    padding: 2px 7px 2px 7px;
}
table.boxresults th {
    text-align: center;
    font-size: 1.1em;
    border: 1px solid #444;
    border-width: 0px 0px 1px 0px;
}
table.boxresults td.browser {
    text-align: right;
}
</style>

<table class='boxresults'>
<tr>
<th></th><th>Table</th> <th>Box</th> <th>Flex</th>
</tr><tr>
<td class='browser'>Firefox 36/35:</td> <td>&#x2714 20/1 fps</td> <td>&#x2714 42/20 fps</td> <td>&#x2714 32/10 fps</td>
</tr><tr>
<td class='browser'>Chromium 41/40:</td> <td>&#x2714 55/28 fps</td> <td>&#x2714 55/45 fps</td> <td>&#x2714 60/40 fps</td>
</tr><tr>

<td class='browser'>IE 11:</td> <td>&#x2714 60/- fps</td> <td>fail</td> <td>&#x2714 60/- fps</td>
</tr><tr>
<td class='browser'>IE 10:</td> <td>~</td> <td>fail</td> <td>~</td>
</tr><tr>
<td class='browser'>IE 9:</td> <td>fail</td> <td>fail</td> <td>fail</td>

</tr><tr>
<td class='browser'>Qt Webkit:</td> <td>&#x2714</td> <td>&#x2714 </td> <td>&#x2714 </td>
</tr><tr>

<td class='browser'>Iceweasel (RaspPI):</td> <td>&#x2714 </td> <td>&#x2714 </td> <td>&#x2714 </td>
</tr><tr>
<td class='browser'>Ephiphany (RaspPI):</td> <td>&#x2714 </td> <td>&#x2714 </td> <td>&#x2714 </td>
</tr><tr>
<td class='browser'>Chromium (RaspPI):</td> <td>&#x2714 </td> <td>&#x2714 </td> <td>&#x2714 </td>
</tr><tr>

<td class='browser'>Firefox (mobile):</td> <td>&#x2714 </td> <td>&#x2714 </td> <td>&#x2714 </td>
</tr><tr>
<td class='browser'>Standard Android (mobile):</td> <td>&#x2714 </td> <td>&#x2714 </td> <td>fail </td>

</tr>
</table>

Notes:

* On Linux, Chrome does not resize the content until you release the
  mouse. In this case the developer mode was used to resize either width
  or height.
* On Raspberry Pi, all browsers do not resize the content until you
  release the mouse.
* The standard Android browser that was tested is from a rather old phone.
* On IE10, the Flex method almost works, but it seems that things go wrong
  when there is deeper nesting (the toplevel hbox only shows the left vbox).
* With the Table method, the minimum size is not taken into account if
  flex > 0.
* In the Box method the elements seem just a bit too small on Firefox.


## Conclusions

One could argue about how important performance really is. Resizing is
not something that happens all the time. On some browsers (in particular
on mobile devices) the resize event is not fired until you're done
dragging the window border. One can also imagine a hybrid approach where
the browser fires resize events during dragging, but not *all* the time.
Perhaps this is how IE gets its surprisingly high performance.

Even though performance may not matter that much, the performance of
the Table method is just terrible. In addition, it is not a true
box-layout because natural size is not taken into account when flex >
0. Avoid using tables for layout. Really, don't use 'm.

The Box method works pretty well, but is not supported on IE and has
some issues on other browsers as well. On Firefox it seems slightly
faster than the Flex method, but this might be because it is cutting
some corners.

It’s good to see that the Flex method is so well supported. Even though
its specification is officially still in draft, it works on a wide range
of browsers. It's the clear winner according to this comparison.
