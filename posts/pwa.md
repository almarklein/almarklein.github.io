# An effective approach to do Progressive Web Apps

<!-- DATE: 2021-03-10 -->
<!-- TAGS: web, js -->
<!-- AUTHOR: Almar -->

This post explains the approach that I took to make TimeTagger a PWA (Progressive Web Application). There are many ways to implement a PWA (or in particular the Service Worker), and I don't claim that this approach is the best. But this approach is relatively simple and should be applicable in many cases.

<!-- END_SUMMARY -->

Some benefits of this approach are:

* A relatively simple solution that requires little maintenance.
* Fast load times and good offline support because of reliance on cache.
* A new version of the application is automatically installed when the app's contents change.
* You can make use of the Service Worker workflow to notify users of a new version.


![An old smartphone on a wooden top](images/phone.jpg)
<br /><small><i>
Image via maxpixel (CC0 public domain)
</i></small>


## Introduction

A [Progressive Web Application](https://en.wikipedia.org/wiki/Progressive_web_application), or PWA, is a website that can be installed as a native-looking app on mobile devices (and on desktop with the Chrome browser). It is a much easier way to bring an app to mobile devices than creating an app for the App store / Play store. If a website meets the right criteria, the browser will initiate a sequence that allows the website to prompt the user to install the app. One of these criteria is that the website has a Service Worker which provides proper off-line support.

A [Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) is a script that runs in your browser making it possible for a website to provide a good off-line experience. It also deals with push notifications (but we don't cover that here). It provides offline support by caching the website's assets and then serving from this cache instead of the network. This sounds simple, but there are many ways in which this can be implemented, each with their own pros and cons. 


[TimeTagger](https://timetagger.app) is an open source timetracking app I'm developing. By making it a PWA, my users can install it on their mobile device, while it costs me little extra work.


## The manifest

One of the PWA criteria is to provide meta-data bout the application in the form of a manifest. Nothing special [here](https://github.com/almarklein/timetagger/blob/main/timetagger/app/timetagger_manifest.json). You'll also need to let the browser know where the manifest here. Just add something like this to the `<head>` section of the page: 

```html
<link rel="manifest" href="timetagger_manifest.json">
```



## The Service Worker

I'm not going into all the details of a Service Worker, because there are plenty of online resources that already do this.

### Strategies

There are many possible strategies to deal with caching in a Service Worker. You can read more on these e.g. [here](https://developers.google.com/web/ilt/pwa/caching-files-with-service-worker) or [here](https://web.dev/offline-cookbook/). 

With the simplest strategy, sometimes called cache-first, you first try to load from the cache. If that does not work, you load from the network. You'll want to preload all assets during installation so that all necessary assets are in the cache.  This approach does exactly what I needed in a simple way, but comes with one caveat: the app will only update when the service worker script changes (because only that will trigger the browser to re-install). 

I have also considered "network first" and "cache then network", but these strategies become quite complex to implement and have their own downsides, like being slow to start up when offline, or users having to refresh twice to get a new version.

### Cache-first-with-hash

I took me a while to realize how we can make cache-first work. It sounds obvious in hindsight, but it felt like a revelation at the time: what if we include a hash of the asset contents in the Service Worker script? 

This is the "secret sauce" of the method proposed here, and it comes with additional benefits: because the application is automatically updated when (and only when) any of the assets change, and the browser notifies of when this happens, it becomes easy to include a workflow to notify the user when a new version is available (or even auto-refresh the page).

Sidenote: you may think (like I did at first) why not use random string? This works, but it goes horribly wrong when your website is run in a scaled fashion (with multiple servers). Plus it causes a new "version" on each server reboot.

### The script

Let's first go through the script that I'm using and explain it step by step. The full version is [here](https://github.com/almarklein/timetagger/blob/main/timetagger/app/sw.js). 

At the start, it defines two variables. Both of these will get replaced by the server. The `currentCacheName` will include the hash from the assets, and will also have a "timetagger" prefix, we'll see why. The `assets` will be set to the names of the assets to store into cache on installation:

```js
var currentCacheName = 'timetagger_cache';
var assets = [];
```

Next, there is some boilerplate to register the event listener. Of interest is the `skipWaiting()`, which makes that the browser will always install a new version of the website, even if it may currently be open in one or more tabs (it does not wait for these tabs to close). This is not a problem in my use-case because all assets load when the app starts, but it may be in specific cases.

```js
self.addEventListener('install', event => { self.skipWaiting();  event.waitUntil(on_install(event)); });
self.addEventListener('activate', event => { event.waitUntil(on_activate(event)); });
self.addEventListener('fetch', on_fetch);
```

The next piece of code shows the app being installed. You can see how the `assets` variable is used that will be written by the server. All asset names are prefixed with "./" because (in my case) the assets are relative to the path of the Service Worker scrip.

```js
async function on_install(event) {
    console.log('[SW] Installling new app ' + currentCacheName);
    let cache = await caches.open(currentCacheName);
    await cache.addAll(assets.map(asset => "./" + asset));
}
```

Next is the code to activate the Service Worker, which is where the old caches are cleared. The cache name is prefixed because all service workers on a domain share the same cache (this can be a problem especially on localhost).

```js
async function on_activate(event) {
    let cacheNames = await caches.keys();
    for (let cacheName of cacheNames) {
        if (cacheName.startsWith("timetagger") && cacheName != currentCacheName) {
            await caches.delete(cacheName);
        }
    }
    await clients.claim();
}
```

Here we have the most important function that handles a fetch. It does a check to make sure we'll want to try the cache in this case. You can see how, if the server does not set the `assets` variable, the Service Worker will behave like a normal website (without offline support).

```js
function on_fetch(event) {
    var requestURL = new URL(event.request.url);
    if (
        (requestURL.origin == location.origin) &&
        (requestURL.pathname.indexOf('/api/') < 0) &&
        (assets.length > 0)
    ) {
       event.respondWith(cache_or_network(event));
    }  // else do a normal fetch
}
```

Finally, the `cache-first` implementation:

```js
async function cache_or_network(event) {
    let cache = await caches.open(currentCacheName);
    let response = await cache.match(event.request);
    if (!response) {
        response = await fetch(event.request);
    }
    return response;
}
```

Together, these samples form the complete Service Worker. 



## Modifying the Service Worker script on server start-up

As mentioned above, the server will need to update the service worker script for it to work. Otherwise it will behave like a normal website. In TimeTagger this happens [here](https://github.com/almarklein/timetagger/blob/main/timetagger/server/_assets.py). We'll walk along the steps again.

We define a function that accepts a dictionary of assets. The TimeTagger application is small enough to simply load all assets in memory. If your assets are on disk, you'd need slightly different code, but the still approach applies. This code is in Python, but the same approach is applicable in other languages.

We first take the Service Worker script:

```py
def enable_service_worker(assets):
    sw = assets.pop("sw.js")
    ...   
```

Next, we generate a hash from the asset contents (which can be bytes or str). We use sha1, just like Git.

```py
    # Generate hash based on content. Use sha1, just like Git does.
    hash = hashlib.sha1()
    for key in sorted(assets.keys()):
        content = assets[key]
        content = content.encode() if isinstance(content, str) else content
        hash.update(content)
    # Generate cache name.
    hash_str = hash.hexdigest()[:12]  # 6 bytes should be more than enough
    cachename = f"timetagger_{versionstring}_{hash_str}"
```

Generate the list of assets:

```py
    asset_list = list(sorted(assets.keys()))
```

And finally we update the code:

```py
    replacements = {
        "timetagger_cache": cachename,
        "assets = [];": f"assets = {asset_list};",
    }
    for needle, replacement in replacements.items():
        assert needle in sw, f"Expected {needle} in sw.js"
        sw = sw.replace(needle, replacement, 1)
    assets["sw.js"] = sw
```



## Registering the service worker

We need to tell the browser to register the service worker. In Timetagger we do that [here](https://raw.githubusercontent.com/almarklein/timetagger/main/timetagger/app/index.md). Let's consider the most notable parts.

The function starts by defining a structure to let the rest of the application access the PWA logic. Don't worry about the details.

```js
function register_service_worker() {
    if (!('serviceWorker' in navigator)) { return; }  // exit if SW not supported
    
    window.pwa = {
        sw_reg: null, // set when sw is registered
        deferred_prompt: null,  // set when browser considers this a PWA
        install: async function() {
            window.pwa.deferred_prompt.prompt();            
            window.pwa.deferred_prompt = null;
        },
        update: function () {
            if (window.pwa.sw_reg) { window.pwa.sw_reg.update(); }
        },
        show_refresh_button: function () { /* not of interest for this post */ }
    };
    
    ...
```

Next is registering the Service Worker, and storing the `reg` object.

```js
    navigator.serviceWorker.register('sw.js').then(reg => { window.pwa.sw_reg = reg; });
```

The next part is what you'll see in any tutorial on Service Workers. This is the event that the browser will emit if it considers the website suitable for a PWA. The `deferred_promp` object is stored, so we can detect that the app is installable. The user can then click an install-button in our app, causing `deferred_prompt.prompt()`to be called.

```js
    window.addEventListener('beforeinstallprompt', (e) => {
        e.preventDefault();  // Prevent the mini-infobar from appearing on mobile
        window.pwa.deferred_prompt = e;  // Store event for later use
    });
```

We can detect when the browser has installed a new version. If this happened within 3 seconds after page load, we auto-reload the page. Otherwise we'll show a small notification in the app, asking the user to refresh the page.

```js
    var page_start_time = performance.now();
    navigator.serviceWorker.addEventListener('controllerchange', function () {
        console.log("New service worker detected.")
        // Prevent continuous refresh when dev tool SW refresh is on
        if (page_start_time === null) { return; }
        if (performance.now() - page_start_time < 3000) {
            page_start_time = null;
            window.location.reload();  // User just arrived/refreshed, auto-refresh is ok
        } else {
           window.pwa.show_refresh_button();  // Prompt the user to refresh instead
        }
    });
```

Finally, we set a timer to periodically check for updates. Users that always have the app open in a tab won't refresh the page, but this way still get notified of updates.

```js
var nhours = 4;
window.setInterval(() => {window.pwa.update()}, nhours * 60 * 60 * 1000);
```

