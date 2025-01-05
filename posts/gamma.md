# Gamma and sRGB in visualisation

<!-- DATE: 2022-09-29 -->
<!-- TAGS: python, viz -->
<!-- AUTHOR: Almar -->

Gamma correction and the sRGB colorspace are an often undervalued topic in computer graphics. Yet it's important to understand it if you work with colors. In this post I first give a brief explanation, and then dive deeper to explain different facets, and also explain how it affects render engines.

<!-- END_SUMMARY -->

<img alt='a retro camera lens' src='images/camera.jpg' />
<br /><small><i>
Image by Marc Mueller (CC0) </i></small>

----



## The short story

<style>
#linear_srgb, #linear_physical {
    background:#000; padding: 2px; display:inline-block;
}
.gradientblock {
    display: inline-block;
    min-width: 20px;
    min-height: 40px;
    max-width: 20px;
    max-height: 40px;
    padding: 3px;
    font-size: 70%;
}
</style>

<script>
function make_srgb_gradient() {
    let container = document.getElementById('linear_srgb');
    container.innerHTML = "";
    let n = 20;
    for (let i=0; i<=n; i++) {
        let p = 255 * i/n;
        let el = document.createElement("div");
        el.className = "gradientblock";
        el.innerHTML = i/n;
        el.style.background = "rgba(" + p + ", " + p + ", " + p + ", 1.0)";
        el.style.color = (p < 128) ? "#99f" : "#009";
        container.appendChild(el);
    }
    let el = document.createElement("div");
    el.style.color = "#fff";
    el.innerHTML = "<br>srgb";
    container.appendChild(el);
}
function make_physical_gradient() {
    let container = document.getElementById('linear_physical');
    container.innerHTML = "";
    let n = 20;
    for (let i=0; i<=n; i++) {
        let p = Math.pow(i/n, 1/2.2) * 255;
        let el = document.createElement("div");
        el.className = "gradientblock";
        el.innerHTML = i/n;
        el.style.background = "rgba(" + p + ", " + p + ", " + p + ", 1.0)";
        el.style.color = (p < 128) ? "#99f" : "#009";
        container.appendChild(el);
    }
    let el = document.createElement("div");
    el.innerHTML = "<br>physical";
 		el.style.color = "#fff";
    container.appendChild(el);
}
window.onload = function () {
   make_srgb_gradient();
   make_physical_gradient();
};
</script>

### The human eye and sRGB

The human eye is more sensitive to darker colors than for lighter colors. The sRGB colorspace accounts for this; in this space colors are perceptually linear. This makes them easier to work with, plus they can be stored more efficiently. In practice, most colors that you encounter as a programmer are likely sRGB.

The gradient below shows how sRGB colors are *linear to human perception*. The steps between the different shades are equal (except for minor differences due to your monitor setup and your eyes/brains).

<div id='linear_srgb'>DIV SRGB</div>

### Physical colors

If you want to do calculations with colors, it may be better to do so in physical space, where the colors are linear w.r.t. the light intensity (number of photons). That way you'll get results that are physically more correct and therefore look better.

The gradient below shows how colors in physical space, which are *physically linear*, appear non-linear to the human eye.

<div id='linear_physical'>DIV PHYSICAL</div>

A note on terminology. Some posts about this topic call the physical space the "linear space". I find this confusing, because the point is that sRGB is linear w.r.t. perception, whereas physical space is linear w.r.t. physics/photons/lumen. I've also seen "gamma space", "scene space", and ThreeJS [calls it](https://matt77hias.github.io/blog/2018/07/01/linear-gamma-and-sRGB-color-spaces.html) "Linear-sRGB" to stress that it has the same gamut (color range) as sRGB.

### Gamma decoding

Converting between these two colorspaces can be done relatively easily using the power law:

```py
color_physical = pow(color_srgb, 2.2)
```

This is also called gamma correction or gamma decoding.

### How to deal with colors

Now that we've established the difference between these two colorspaces, how should you use this information?  Well, in some cases you can actually just ignore it all. Your monitor should be given an sRGB image (we'll explain more on this below), so if you just pass the color data to the monitor unchanged, all might be ok!

This changes when you want to do calculations with colors, especially if these simulate certain physical processes. These can include e.g. blending, antialiasing, and lighting. In that case we need to convert to physical colors and back:

<img alt='gamma encoding and decoding' src='images/gamma encoding decoding.png' width='700px'/>

In the colorize step the data is transformed into a color. Although most color values that you encounter are sRGB, this is not always the case. Some image formats can tell in the metadata what gamma function was used to encode the image. Further, the data may represent *something* that you simply want to encode using color, e.g. using a colormap. Once you have the (sRGB) color, you transform it to a physical color.

You have a choice here to convert to sRGB first or directly to physical. How to deal with this is mostly a matter of API design.

Once you have the physical color, you can go wild on any calculations, before converting back to sRGB. Note that you want to store the physical color using a higher precision to avoid artifacts.



## Diving deeper

Now that we've covered the basics, I'll explain a few aspects in more detail.

### The human eye

Let's start at the end of the pipeline: your eyes. For whatever evolutionary reason, our eyes are more sensitive for darker colors. Maybe because this makes it easier to detect a tiger hiding in the shadows. Another way to say this is that if a color becomes half as bright (in terms of photons), it is observed as still relatively bright. This non-linearity can be modeled quite accurately using a power law with gamma 0.45.

<img alt='Power law with gamma 0.45' src='images/gamma_0_45.png' width='300px'/>

### Monitors

Historically, display devices such as monitors were also non-linear. Their transfer function could also be described using a power law, with a gamma between 2.0 and 2.5. Most monitors today have a gamma of 2.2 to match human perception.

<img alt='Power law with gamma 2.2' src='images/gamma_2_2.png' width='300px'/>

This transfer function is the exact opposite of the previous one. In fact `1/2.2= ~0.45`. This means that whatever we feed to the monitor is perceptually linear. Now you know where sRGB comes from.

(To be more precise, the sRGB transform is close to the gamma function, but differs slightly to account for other perceptual factors, see [Wikipedia](https://en.wikipedia.org/wiki/SRGB) for details.)

### Storing colors

We briefly mentioned that it's efficient to store colors in sRGB. The available bits are then optimally used, because the step size (in terms of human perception) is equal from dark to bright. With 8 bits per color, the transition from one color to the next is so small that humans (typically) cannot discern them.

If, however, colors would be stored in physical space, the darker colors are encoded using relatively few bits, resulting in visual artifacts:

<img alt='A gradient, linear in srgb, stored in physical space' src='images/gradient 8bit physical.png' width='745px'/>

### Why things are usually stored as sRGB

Now you can see why most image formats encode the pixels in sRGB. Less bits are required to store good looking images. And the data can be fed directly to the monitor. The latter reason is perhaps not so important now, but in the early days of computers it was. Further, because its easier for designers to work with sRGB colors (they care only about perception) most other colors (e.g. style sheets) are sRGB too.

That said, there are many other color spaces, which have their own purposes. At least now you should be more aware.

### Scientific data

Another thing worth mentioning is that scientific oriented image formats care more about accurately storing the physical data than how things are perceived. E.g. CT and MRI data. If you work with scientific data, you may need to be extra aware. Often though, the values are not shown on the screen directly, but contrast limits are applied, followed by a colormap. You can consider the application of the colormap the conversion into sRGB space.

On this subject, if you plan on doing image processing on more regular image data, be aware that its likely stored as sRGB. Depending on what you try to achieve, it may be good to first transform it to physical-linear space. If you only care about contrast though, the sRGB image is probably better, because camera's try to create good looking images, which generally means a somewhat uniform contrast (in sRGB).

## Implications for visualization

### Blending

If you naively blend multiple objects in sRGB space, you'll get results that may look right on first sight, but which are in fact wrong. Blending involves adding color components together, scaled with the alpha value. For example, imagine a black background with two white planes with alpha 0.5. Blending in sRGB space (i.e. without taking gamma correction into account) produces the following result.

<img alt='Two transparent planes blended the wrong way' src='images/transparent1.png' width='200px'/>

The pixel values in the above image show that the white plane (all 255) is reduced exactly half in intensity. But this is wrong if you consider an alpha of 0.5 to mean that half the light is let through. This means that the math needs to be applied in physical space:

<img alt='Two transparent planes blended the right way' src='images/transparent2.png' width='200px'/>

In this case we see that an alpha of 0.5 still produces a relatively bright surface, because the human eye is more sensitive for darker colors. (Note that the images above (and the shown pixel values) are in sRGB space, linear for perception.)

As a side-note, in the browser the alpha channel is applied in sRGB space (in both css and canvas). I guess the argument is that in most cases the blending does not have to be physically correct, and users may expect the simpler math.

### Antialiasing

With antialiasing, the alpha channel (transparency) is used to encode the coverage of a pixel. As we saw in the above section, these calculations simulate physical processes and must be applied in physical space.

### Lighting

It's easy to see that the chosen colorspace would affect the end-result for lighting calculations a lot. Especially for photorealistic rendering. See [this blog post](https://morris-photographics.com/photoshop/articles/png-gamma.html) for more details. Below you see a sphere being lit from the side. On the left the lighting calculations are done in sRGB, on the right in physical colorspace. You can see how this results in a shaper edge because medium-dark colors are still perceived as relatively bright. Fun fact, this sharp edge can also be seen when we look at the partly lit moon.

<img alt='A lit sphere, lighting applied in srgb (left) and physical (right)' src='images/spheres_lit_srgb_physical.png' width='400px'/>

### sRGB textures

Most GPU api's support a special kind of texture for dealing with sRGB colorspaces. In wgpu this is simply a texture with the `rgba8unorm_srgb` or `bgra8unorm_srgb` format. Such a texture will auto-convert between sRGB and physical colors automatically. Plus it's likely implemented in hardware, so it comes at no additional cost.

Just like in any texture you can store any value you like, in any colorspace you want. However, because of how sRGB textures work, you probably should consider the values in the texture to be stored in sRGB space. This means that the available bits are used effectively, taking into account the sensitivity of the eye.

How sRGB textures works specifically:

* If you render to it, you should provide values in physical space; they will be converted to sRGB.
* If you sample from it, you get values in physical space (the sampling includes an auto-conversion).
* If you upload data to it, that should be in sRGB space.
* The monitor will use the *raw* data stored in the texture (because the monitor needs the sRGB format).

## Resources

Here's a list of resources that I found useful.

* [what every coder should know about gamma](https://morris-photographics.com/photoshop/articles/png-gamma.html) is probably the most complete resource I've found.
* [importance-being-linear](https://developer.nvidia.com/gpugems/gpugems3/part-iv-image-effects/chapter-24-importance-being-linear) explains things from a GPU perspective, and how things go wrong if you don't use a physical colorspace.
* [OpenGL Gamma Correction](https://learnopengl.com/Advanced-Lighting/Gamma-Correction) explains things from the point of GPU rendering.
* [wgpu srgb conversions](https://github.com/gfx-rs/wgpu/wiki/Texture-Color-Formats-and-Srgb-conversions) explains the use of sRGB textures.
* [PNG gamma](https://morris-photographics.com/photoshop/articles/png-gamma.html) explains the history of gamma in PNG images and how browsers deal with that.
* [Understanding gamma correction](https://www.cambridgeincolour.com/tutorials/gamma-correction.htm)
* [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) on Wikipedia.
