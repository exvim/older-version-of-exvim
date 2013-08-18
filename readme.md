#Bryant
###A theme for [Jekyll](https://github.com/mojombo/jekyll) created with long-form writings, essays and beautiful photography in mind.

[![Bryant Demo](http://stylehatch.github.io/bryant/images/bryant-demo.png)](http://stylehatch.github.io/bryant)

It is based off of one of our latest [premium themes](http://byron.stylehatch.co) for tumblr at [Stylehatch](http://stylehatch.co/). We're big fans of Jekyll and the open source community, so we are trying something new.
####[See The Demo](http://stylehatch.github.io/bryant)
All of the source code for the demo site is available for your reference in the [gh-pages branch](https://github.com/stylehatch/bryant/tree/gh-pages).

## Installation

Setting up this theme is fairly simple, but if you aren't already familiar with Jekyll take some time to read through their [documentation](http://jekyllrb.com/docs/home/).

- Install Jekyll: `gem install jekyll`
- [Fork this repository](https://github.com/stylehatch/bryant/fork)
- Clone it: `git clone https://github.com/YOUR-USER/bryant`
- Run the Jekyll server: `jekyll serve`

You should have a server up and running locally at <http://localhost:4000>.

[More on basic usage](http://jekyllrb.com/docs/usage/)

## Customization

Next you'll want to change a few things. Most of them can be changed directly in
[_config.yml](https://github.com/stylehatch/bryant/blob/master/_config.yml). That's where we'll pull your name, Twitter username, color variables, and things like that.

There's a few other places that you'll want to change, too:

- [CNAME](https://github.com/stylehatch/bryant/blob/master/CNAME): If you're using
  this on GitHub Pages with a custom domain name, you'll want to change this
  to be the domain you're going to use. All that should be in here is a
  domain name on the first line and nothing else (like: `example.com`).
- [favicon.ico](https://github.com/stylehatch/bryant/blob/master/favicon.ico): 
  This is the Style Hatch logo for displaying in the address bar. You should change it to whatever you'd like.
- [apple-touch-icon.png](https://github.com/stylehatch/bryant/blob/master/apple-touch-icon.png): 
  Again, this is the Style Hatch logo, and it shows up in iOS and various other apps
  that use this file as an "icon" for your site.

For custom CSS, there is an included blank screen.css file for that purpose.

## Adding Posts
There are currently 5 supported post types in this theme. These are defined in the posts YAML front-matter using the variable `type: `

These types affect how the post is rendered. Some post types have extra post specific front-matter like `photo_url` or `link`. You can see how they work in the example posts for each type.

#### Text
Example YAML front-matter for this post type:

    ---
    layout: post
    title: Blog Like a Hacker, In Style
    category: posts
    type: text
    ---


#### Photo
Example YAML front-matter for this post type:

    ---
    layout: post
    title: Photos Look Great
    category: posts
    type: photo
    photo_url: http://somesite.com/images/someimage.jpg
    camera: Fujifilm Finepix X100
    apeture: f/4
    exposure: 1/250th
    focal_length: 23mm
    ---


#### Embed
Example YAML front-matter for this post type:

    ---
    layout: post
    title: Magnetic Magic
    category: posts
    type: embed
    embed_code: <iframe src="http://player.vimeo.com/video/63773788?portrait=0&amp;badge=0" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
    ---


#### Quote
Example YAML front-matter for this post type:

    ---
    layout: post
    title: There is nothing to writing. All you do is sit down at a typewriter and bleed.
    category: posts
    type: quote
    source: Ernest Hemingway
    ---


#### Link
Example YAML front-matter for this post type:

    ---
    layout: post
    title: Style Hatch - Fresh Designs to Show Off Your Genius
    category: posts
    type: link
    link: http://stylehatch.co/
    ---


### Shortname
For long post titles, there is an optional `shortname: ` variable that can be added to the YAML front-matter. If included on a post, the archive page will display the shortname instead of the full title. This is especially useful for long quote posts.

These are mostly specifc to the Bryant Jekyll theme. See the Jekyll documentation for [more on adding posts](http://jekyllrb.com/docs/posts/).

## Creating Pages
All HTML or Markdown files with YAML front-matter will be parsed as individual pages separate from posts. In order to get these to show up in the main navigation they will need the following YAML front-matter.


    ---
    layout: page
    title: your title
    weight: 3
    ---


Weight is used to determine the order within the navigation items (1-10).

[More on creating pages](http://jekyllrb.com/docs/pages/)

## Deployment

You should deploy with [GitHub Pages](http://pages.github.com).

All you should have to do is rename your repository on GitHub to be `username.github.io`. Content from the master branch of your repository will be used to build and publish the GitHub Pages site, so make sure your Jekyll site is stored there.

If you're using it for a Project Page, create a new branch named `gh-pages`. The content of this branch will be rendered using Jekyll, and the output will become available under a subpath of your user pages subdomain, such as `username.github.io/project`

For more, see the Jekyll's documentation on [deploying to GitHub Pages](http://jekyllrb.com/docs/github-pages/) as well as [other deployment methods](http://jekyllrb.com/docs/deployment-methods/).

## Licensing - MIT License

Copyright 2013 Style Hatch http://stylehatch.co

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Credits

* [Jonathan Moore](http://github.com/jonathanmoore) - *[@moore](http://twitter.com/moore) | [jonathanmoore.com](http://jonathanmoore.com)*
* [Mikey Wills](http://muke.me) - *[@mukealicious](https://twitter.com/mukealicious) | [muke.me](http://muke.me)*

All icons are from Entypo pictograms by Daniel Bruce — [www.entypo.com](http://www.entypo.com)

## Thanks

Shout out to [@holman](https://twitter.com/holman) for the great example of how to build a nice Jekyll theme like he's done with [Left](https://github.com/holman/left).
