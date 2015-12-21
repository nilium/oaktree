# OakTree

## CAUTION: PROJECT NOT MAINTAINED

As of 2015, I've ceased using OakTree in favor of [Hugo](https://gohugo.io). If you were for any reason using OakTree, I recommend checking out Hugo, as it accomplishes all of the same goals and a few more without being slow nor difficult to maintain.

## What in the nine hells is OakTree?

OakTree is an odd little static HTML blog gem thingy written by Noel R. Cower (hereinafter "yours truly" or just "I," because writing in the third person about my work is annoying).  It is designed to fit my purposes - which is to say a very simple blog with very simple needs (has text, posts, some links, and my template).  At present, it works moderately well at generating simple blogs – that is, HTML-only, no RSS feeds yet.

The entire interface for OakTree goes through its lone executable, `oak`.  `oak` is intended to allow you to create posts, watch for changes, generate output HTML, and so on.  If it's not obvious, this is all designed to be _very_ simple, because complex setups would be overkill.

## How do I get all up in this OakTree?

For one, I apologize that I've used the phrase "get all up in X."  For two, the only way to use OakTree is to download this and build the gem and install it yourself.  This is actually fairly simple, provided I didn't commit something which opened a portal to hell.  You really just want to do something like this:

	$ rake package
	$ cd pkg
	$ gem install oaktree-<version>.gem
	... or, more likely ...
	$ sudo gem install oaktree-<version>.gem

And, if you use rbenv, run `rbenv rehash` afterward, of course.  I don't know what to tell you about RVM (aside from it being the destroyer of worlds, but that's another issue entirely), but you can figure it out.  It's probably got a manpage or something.

After that, hop into some empty directory and run `oak init` to start a blog.  At this point, you can being creating posts by either a) creating your own files in the _source/_ directory or using `oak newpost [title]` (where `[title]` is the title of your post).  If you want to customize the blog's template, which I imagine you will, head on into _template/_ and begin tweaking _blog.mustache_.  You will probably want to break things up into smaller template pieces to avoid getting bogged down with figuring out what's where in the mess of mustaches.  For documentation on all available template tags, read _tags.md_.  Finally, you'll want to configure your _blog_spec_ file.  See _specs.md_ for info what options are available there, or just read _specification.rb_.

Once you've got all those things sorted out and you want to generate a blog, run `oak sync` in the same directory as your _blog_spec_ (I might do something git-ier later for that).  This will build the HTML for your blog under _public/_.  If you make further changes to the source files, you can run `oak sync` again and it will rebuild only files that need to be rebuilt (hopefully).  Should you make changes to the template, you'll need to run `oak rebuild` to rebuild the entire blog (or delete the contents of _public/_), as `oak sync` does not account for template changes (it's a lot harder to figure out template dependencies accurately and doing it poorly seems like a bad idea, so I don't do it at all).

You may now commence uploading or using rsync or what have you to shunt your blog up somewhere.  This may also be compatible with GitHub pages, but I'm not sure.  Give it a shot.

## What kind of license is OakTree under?

How kind of you to ask.  OakTree is licensed under the WTFPL-2:

    Copyright (C) 2012 Noel Cower <ncower@gmail.com>
    
               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
    
     0. You just DO WHAT THE FUCK YOU WANT TO.

If you have any questions about licensing, please direct them to the incinerator, because the license (also found in the _COPYING_ file that should have accompanied this repository) already answered those questions.

## Anything else I should know?

No, but I'll reiterate this point again: **OakTree is unfinished, very unstable, and very much a work in progress.**  If you attempt to make use of it, there's a good chance I cannot do anything to make your life better or help you, because you've already sealed your fate.

## Why is it called 'OakTree?'

Because it's easy to type and `oak` is even easier to type.  There is a possibility that the entire project will just be renamed to 'oak' just to make me happy and remove four characters that I would otherwise have to type.
