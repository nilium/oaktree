# blog_spec

The blog_spec file is just a bunch of key/value pairs that link to OakTree::Specification attributes.  They're listed below, so prepare for some reading.  No attributes are _required_, but there are some where it should be obvious that you ought to set them.  All but two attributes, `post_path` and `posts_per_page`, defaults to an empty value/string.

When any path is specified, do not include a trailing slash.  Do, however, include a beginning slash.  So, if you want to put your posts in the _foo/bar_ directory under _public_, you specify _/foo/bar_, as _public_ is considered the blog's public root.  That said, OakTree will automatically add a beginning slash if you forget it and strip trailing slashes, so it's not that important.

## Keys

* `title: Blog title`
    
    This is the blog's title -- plain and simple.

* `description: Description of your blog`
    
    A brief description of the blog.  You can put whatever you want in here.

* `author: Sir Herp Derpington`
    
    The name of this blog's author.  OakTree blogs can only have one author, so keep that in mind.

* `base_url: http://url.to.your.blog.com`
    
    A base URL for where the blog is located.  This is essentially where your _index.html_ should reside.  Do not include a trailing slash.

* `post_path: /post`
    
    Where generated HTML for posts is placed (that is, if it goes somewhere beneath the root).  Defaults to `/post`, but can be blank or anything else.

* `posts_per_page: 10`
    
    The number of posts rendered per page of the blog.  If you don't include navigation, this is more specifically just the number of pages viewable on the front page.  Defaults to `10`.

* `reversed: no`
    
    Whether the blog is generated in reverse-chronological order or not.  If `no` (or `false` or `0`), the most recent post is visible at the top of the front page and posts are ordered newest to oldest.  If `yes` (or `true` or `1`), the first post made to the blog is visible at the top of the front page, and posts are ordered oldest to newest.
    
    This is a bit of an odd option, but should you want to present a clear timeline, this works fairly well.  It can also be useful if you wanted to use this to generate an HTML book that was for some reason had its pieces ordered chronologically, though I don't know why you'd use OakTree for that.