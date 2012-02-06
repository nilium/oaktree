# Templates

First off, OakTree uses [Mustache] for templates. So, go read its documentation then you can come on back and continue reading this. Alright, now that we've got that out of the way, let's talk about where these go.

All of your .mustache template files must be placed under `BLOG_ROOT/templates`. It's pretty simple, don't over-think this. Now, there is only one required template: `blog.mustache`. This is the template `Blog` loads when OakTree generates its HTML, so it's pretty important. This is your blog's index, basically.

In `blog.mustache`, you can do whatever you want from there. That said, there are a number of tags that're worth knowing. The tags below are all separated by context, and there are only three contexts: Blog, Post, and PostArchive. There's not a lot there because this is purposefully simple.

It's worth keeping in mind, however, that the `Blog` class renders templates in three different modes: archive, single, and home. These are fairly simply to understand, but documentation follows nonetheless.


------------------------------------------------------------------------------


# Blog Modes

Each blog mode differs by the way it composes pages and which tags are functional. For instance, some tags that work in archive mode made not work in single and home mode.

## Archive

archive mode pages render all posts from each month. Empty months are not represented and do not have any HTML generated. To explain this in a boring and slightly clearer manner, this means that an archive page's HTML will contain all posts from only one month.

## Single

Pages in single mode is composed of a single post. In other words, a single mode page is just looking at one post.

## Home

Each page in home mode represents a chronological series of paginated posts. Pages only contain however many posts you've specified in your `blog_spec`'s `posts_per_page` attribute. Ideally, you should not generate more than the index when in `home` mode, as synchronizing a large body of posts like this would be fairly painful.

Home mode has no special tags, though it lacks access to both archive and single mode tags.


------------------------------------------------------------------------------


# Tags by Context

## Blog Context Tags

### General Tags

General tags provide you with some information about the blog itself or offer some functionality that isn't specific to a particular mode.

#### `local_path`

This tag is mainly for use by OakTree internally, but you could also use it for debugging if you were testing out something or other. It just emits the absolute path of the file currently being generated.

#### `blog_title`

This is whatever's in your `blog_spec`'s `title` attribute.

#### `blog_author`

Emits the blog author, obviously.

#### `blog_description`

This is whatever you put in your `blog_spec`'s `description` attribute. Your best use of this is probably metadata.

#### `blog_url`

This is the `base_url` attribute from your `blog_spec`. Why the different name? I don't know, let's blame the tides or something. This URL shouldn't have a trailing forward slash unless you went and put one in the `blog_spec` (in which case you shouldn't have).

#### `today`

This is a lambda that takes a format string and emits the current date and time as rendered by `DateTime#strftime`. For example, `{{#today}}%Y %B %-d{{/today}}` renders `2012 February 5` (at least at the time of this writing).

------------------------------------------------------------------------------

### Page Tags

Page tags tell you something about the page. Use them wisely.

#### `archive?`, `single?`, and `home?`

These are section tags that you can use to render content differently between archive, single, and home pages.

#### `pages`, `page`

`pages` emits the total number of pages for the current mode. You probably don't need to use this for anything. `page` emits the current page number which, again, is probably not all that useful.

#### `paged?`

This section tag tells whether there are next or previous pages. This is only true if there's one page.

#### `has_next?` and `has_previous?`

Sectional tags to determine if there are next or previous pages.

#### `next_url` and `previous_url`

Emits URLs for the next and previous pages respectively.

------------------------------------------------------------------------------

### Post Tags

These tags allow you to access the current set of posts or a single post, as well as a few other things. All post tags provide you with a `Post` context when available.

#### `posts`

A section tag providing access to all posts on the current page. You can use this to render blog posts. The following example would render all posts on the given page uniformly:

  {{#posts}}
   <article>
    <h1><a href="{{url}}">{{title}}</a></h1>
    {{content}}
   </article>
  {{/posts}}

#### `post` (single only)

Section tag to access the current post. This only works in single mode. You may also want to read the tags available in a post context.

#### `next_post` and `previous_post` (single only)

These section tags are provided in case you want to pull something from the context of either the next or previous posts in line. They only work in single mode.

------------------------------------------------------------------------------

### Archive Tags

Archive tags provide access to `PostArchive` contexts. Archive tags have fairly limited utility.

#### `archives`

This section tag provides access to all `PostArchive` contexts from newest to oldest. It can be used to render links to all archive pages, for example:

  <ul>
   {{#archives}}
   <li>
    <a href="{{permalink}}">
     {{#date}}%B %Y{{/date}}
    </a>
   </li>
   {{/archives}}
  </ul>

Which might produce something like the following:

  <ul>
   <li>
    <a href="/posts/2012/2.html">
     February 2012
    </a>
   </li>
   <li>
    <a href="/posts/2012/3.html">
     March 2012
    </a>
   </li>
  </ul>

#### `archive` (archive only)

A section tag that provides access to the page's current `PostArchive` context when in archive mode.

#### `next_archive` and `previous_archive` (archive only)

Section tags that provide access to the next (newer) and previous (older) `PostArchive` contexts.

#### `archive_date` (archive only)

A lambda that formats the current archive's date (the first day of the month for the `PostArchive` context) using `DateTime#strftime`. Works the same as the `today` tag.


------------------------------------------------------------------------------


## Post Context Tags

There are no particularly special categories of tag under Post since they're all fairly specific to the post to start.

#### `title`

The post's title.

#### `url`

The post's URL. If the post has a source link, `url` emits the source link, otherwise it emits the post's permalink. If you need to determine which is which, use the `source_link?` tag.

#### `permalink`

Emits a permanent link to this file (or at least as permanent as you can hope a link to a file is). This always points directly to the post.

#### `source_link`

This emits the post's source link, which is specified with the `link` attribute in your post file.

#### `source_link?`

Section tag to determine if there is a source link.

#### `content`

Provides the HTML content of the post. You should wrap this in three curly braces rather than the usual two so Mustache doesn't reformat it. That is, you want to use `{{{content}}}`.

#### `time`

This lambda functions the same as the above `today` tag, but emits the formatted time of the post.

#### `public_path`

Emits the public path for this post. This is only really useful for debugging, since it points to the local file.

#### `slug`

If for some reason you need access to the post slug, this tag provides it.


------------------------------------------------------------------------------


## PostArchive Context Tags

As mentioned above, archive tags generally have little utility. They are useful only when rendering archive mode pages and if you want to provide links to all archives.

#### `year` and `month`

Both of these tags provide the raw year and month numbers for the archive. Unlike other date/time tags, these are not lambdas and do not provide specially formatted output.

#### `date`

This is a lambda that formats the `PostArchive`'s date (the first day of the month and year for this context). It works the same as the `today` tag and other formatted date/time tags above.

#### `permalink`

The `permalink` tag emits a permanent link to the archive page for this `PostArchive` context.

#### `open?`

Sectional tag to determine if this is the current `PostArchive` context being rendered by the `Blog`. You might use this to de-link or highlight the current archive in a list of archive pages.

#### `next_archive` and `previous_archive`

These tags both provide access to archives that follow/precede the current `PostArchive` context. These override the `next_archive` and `previous_archive` tags provided by the `Blog` context above when used in a `PostArchive` context.