# Creating a tiny async framework

<!-- DATE: 2025-01-21 -->
<!-- TAGS: python, async -->
<!-- AUTHOR: Almar -->

Async programming has stirred the Python community in the past years.
Some people adore the performance and elegant code, others hate
how it requires *all* your code to be async.
This post looks into what async does by creating a tiny async framework.

<!-- END_SUMMARY -->

<center>
<img alt='Grok visualizing async' src='images/async.jpg' />
<br /><small><i>Image by Grok</i></small>
</center>

## Why async

The core purpose of async is to deal with cases where the program
execution has to wait for some reason. For instance when it's writing
a file to disk, or downloading a file from the internet.

The classic approach is simply to ... wait. The program is then doing nothing
until the file system or network has done what the program needs it to do
before it can proceed. That's a waste of CPU cycles.

One approach to solve this is using callbacks. When you write the command to
download a file, you also provide a function that will be called when
the file has arrived. Older JavaScript is a good example:

```js
fetch(url, ...).then(response => response.text()).then( text => console.log(text))
```

This works, and the `then` helps make this quite readable, but as
applications get more complex, these things tend to become more messy
and lead to something called "callback hell".

The modern way to write the above is to use async, which is much easier to follow:

```js
response = await fetch(url, ...)
text = await response.text()
console.log(text)
```

That `await` keyword means that the program flow will wait there, except
in such a way that other stuff can run in the mean time.

And this is the main point of aync: it allows you to define multiple tasks,
so that when one task is waiting, the others can run.


## Aync in Python


Have a look at this simple Python function:
```py
def foo():
    do_something()
	do_someting_else()
```

To make it async we can add one word:
```py
async def foo():
    do_something()
	do_someting_else()
```

Though the real power comes when there's waiting involved:

```py
async def foo():
    await sleep(1)
	await download_file()
```


## Aync is contagious

You may wonder whether it's possible to simplify the above example like this:

```py
# FAIL: the outer function *must* be async
def foo():
    await sleep(1)
	await download_file()
```

But we cannot; in order for a function to await something, it must be marked
as async. And therefore the parent function must too, and the function before that, etc. You can see how this forces you to make your whole application async.


## A mini async framework

So what happens if you call `foo()`? You get a coroutine object:

```py
coroutine = foo()
```

Normally you won't use the coroutine object directly; that's the purpose
of the async framework, like Asyncio or Trio. But in this post we will,
because we're going to build our own mini-async-framework!

### A sleep function

To do so, we're first going to create our own little "awaitable" object:


```py
class Sleeper:
    def __init__(self, delay):
        self.delay = delay

    def __await__(self):
        yield {"action": "sleep", "delay": self.delay}
```

which can be created with our own `sleep()` function:

```py
async def sleep(delay):
    await Sleeper(delay)
```

All async frameworks have their own `sleep()` function. In a minute you'll see
why they're not compatible.

That `__await__` method on the `Sleeper` class is a special method that is called
when an object is awaited. It must be a generator, but it is not specified what it should yield. In fact, this is the implementation detail of the async framework. E.g. Ayncio will yield different things than Trio. And we yield our own little info object.


### A task object

A task (in this context) is a wrapper for a coroutine. It keeps track of
the coroutine object, whether it errored, and when it should proceed:

```py
class Task:

    def __init__(self, coro):
        self.coro = coro
        self.error = None
        self.proceed_at = 0
```

To actually run the coroutine, the `coro.send()` method is used:
```py
return_value = self.coro.send(None)
```

The coroutine then takes a single step, and one of three things can happen:

* The coroutine had to wait for something, and the return value is that little dict that the `Sleeper` (or another awaitable) produces.
* The coroutine is done, and it raises `StopIteration`.
* The coroutine raises an error.

(we ignore task cancellation here for the sake of simplicity.)

The below code handles these cases:

```py
import time

class Task:

    def __init__(self, coro):
        self.coro = coro
        self.error = None
        self.proceed_at = 0

    def step(self):
        try:
            wait_info = self.coro.send(None)
        except StopIteration:
            self.coro = None
            return
        except Exception as err:
            self.error = err
            self.coro = None
            return

        action = wait_info["action"]
        if action == "sleep":
            self.proceed_at = time.perf_counter() + wait_info["delay"]
        else:
            self.error = Exception(f"Unknown async action {action!r}.")
```

### A runner

With the task object capable of stepping the coroutine, and exposing
when it should be stepped again, we can create an object that can
run multiple tasks simultaneously:

```py
class Runner:
    def __init__(self):
        self.tasks = []

    def add_task(self, coro):
        self.tasks.append(Task(coro))

    def run(self):
        proceed_at = 0

        while self.tasks:
            time.sleep(max(0, proceed_at - time.perf_counter()))

            now = time.perf_counter()
            proceed_at = now + 1
            for task in self.tasks:
                if now >= task.proceed_at:
                    task.step()
                    if task.error:
                        print("Error in task:", task.error)
                proceed_at = min(proceed_at, task.proceed_at)

            self.tasks = [task for task in self.tasks if task.coro]
```

### Trying it out

And then we can do:

```py

async def main():
    await sleep(1)
    print("main slept")
    await sleep(1)
    print("main slept")
    runner.add_task(sub("harry", 3))
    runner.add_task(sub("ron", 4))
    runner.add_task(fail())


async def sub(name, n):
    for _ in range(n):
        await sleep(0.1)
        print(f"{name} slept")


async def fail():
    await sleep(2)
    raise ValueError("Meh")


runner = Runner()
runner.add_task(main())
runner.run()
```


### The final code

It's very minimal, and it cuts many corners, but it works!

<details>
<summary>The full code for out little async framework</summary>
```py
import time


class Sleeper:
    def __init__(self, delay):
        self.delay = delay

    def __await__(self):
        yield {"action": "sleep", "delay": self.delay}


async def sleep(delay):
    await Sleeper(delay)


class Task:

    def __init__(self, coro):
        self.coro = coro
        self.error = None
        self.proceed_at = 0

    def step(self):
        try:
            wait_info = self.coro.send(None)
        except StopIteration:
            self.coro = None
            return
        except Exception as err:
            self.error = err
            self.coro = None
            return

        action = wait_info["action"]
        if action == "sleep":
            self.proceed_at = time.perf_counter() + wait_info["delay"]
        else:
            self.error = Exception(f"Unknown async action {action!r}.")


class Runner:
    def __init__(self):
        self.tasks = []

    def add_task(self, coro):
        self.tasks.append(Task(coro))


    def run(self):
        proceed_at = 0

        while self.tasks:
            time.sleep(max(0, proceed_at - time.perf_counter()))

            now = time.perf_counter()
            proceed_at = now + 1
            for task in self.tasks:
                if now >= task.proceed_at:
                    task.step()
                    if task.error:
                        print("Error in task:", task.error)
                proceed_at = min(proceed_at, task.proceed_at)

            self.tasks = [task for task in self.tasks if task.coro]


async def main():
    await sleep(1)
    print("main slept")
    await sleep(1)
    print("main slept")
    runner.add_task(sub("harry", 3))
    runner.add_task(sub("ron", 4))
    runner.add_task(fail())


async def sub(name, n):
    for _ in range(n):
        await sleep(0.1)
        print(f"{name} slept")

async def fail():
    await sleep(2)
    raise ValueError("Meh")

runner = Runner()
runner.add_task(main())
runner.run()
```

</details>


## Async adapter in rendercanvas

In [rendercanvas](https://github.com/pygfx/rendercanvas) I recently
implemented a mini-framework that is just a bit more advanced that the one
here. It can sleep and listen to an event.

It's called the
[asyncadapter](https://github.com/pygfx/rendercanvas/blob/main/rendercanvas/utils/asyncadapter.py), because its purpose it to allow running async code in an
event loop that is not normally support async Python (i.e. coroutines), like Qt or wx.

Instead of a runner like we created here, it is driven by a `call_later` function.
Any event-loop can provide that, so this adapter can run on any event loop.

The purpose is to allow code to call the async functions of the WebGPU API, i.e. wait for the GPU. We may make the adapter more advanced as the WebGPU's C-API (wgpu-native) evolves.


## Take it to the next level

A thing that is obviously missing here is being able to wait for IO.
To implement that you'd to meka use of OS-level signals, and/or threading.

Further, awaitable functions may want to return someting:
```py
data = await download(url)
```

That something must be passed to the `coro` here:
```py
        wait_info = self.coro.send(something)
```

That all sounds like a lot of fun, but out of scope for this post. There
will be tons of design decisions to make, which is how Asyncio and Trio
distinguish themselves.
