# OakTree

## What in the nine hells is OakTree?

OakTree is an odd little static HTML blog gem thingy written by Noel R. Cower (hereinafter, yours truly, because writing in the third person about my work is annoying).  It is designed to fit my purposes - which is to say a very simple blog with very simple needs (has text, posts, some links, and my template).  It is currently an unusable work in progress and most likely will be a work in progress for its entire lifespan - the unusable part is questionable, but we'll see how that goes.

The entire interface for OakTree goes through its lone executable, `oak`.  `oak` is intended to allow you to create posts, watch for changes, generate output HTML, and so on.  If it's not obvious, this is all designed to be _very_ simple, because complex setups would be overkill.

## How do I get all up in this OakTree?

For one, I apologize that I've used the phrase "get all up in X."  For two, the only way right now is to download this and build the gem and install it yourself.  This is actually fairly simple, provided I didn't commit something which opened a portal to hell.  You really just want to do something like this:

	$ rake package
	$ cd pkg
	$ gem install oaktree-<version>.gem
	... or, more likely ...
	$ sudo gem install oaktree-<version>.gem

And, if you use rbenv, run `rbenv rehash` afterward, of course.  I don't know what to tell you about RVM (aside from it being the destroyer of worlds, but that's another issue entirely), but you can figure it out, it's probably got a manpage or something.

After that, hop into some empty directory and run `oak init` to start a blog.  At this point, you can being creating posts by either a) creating your own files in `yourblog/source/` or using `oak newpost [title]` (where `[title]` is the title of your post).  This is really _all_ you can do as of this writing, but that'll likely be followed by running `oak sync` later (`oak sync` exists, but is currently just for testing and doesn't do a thing) to generate public files.  If I decide it's worth the trouble, `oak watch` may also be added to monitor for filesystem changes and regenerate HTML as needed.

## What kind of license is OakTree under?

How kind of you to ask.  OakTree is licensed under the ever-lovely MIT license:

	Copyright (c) 2012 Noel R. Cower.
	All rights reserved.
	
	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
	of the Software, and to permit persons to whom the Software is furnished to do
	so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

I personally thing you'd have to try pretty hard to get on the wrong side of this license, but if you or another poor schmuck manage it, do let me know.

## Anything else I should know?

No, but I'll reiterate this point again: **OakTree is unfinished, very unstable, and very much a work in progress.**  If you attempt to make use of it, there's a good chance I cannot do anything to make your life better or help you, because you've already sealed your fate.

## Why is it called 'OakTree?'

Because it's easy to type and `oak` is even easier to type.  There is a possibility that the entire project will just be renamed to 'oak' just to make me happy and remove four characters that I would otherwise have to type.
