require 'test/unit'
require 'oaktree'
require 'tempfile'

POST_CONTENT_FIRST = <<EOT
title: first
time: 2000-01-01 00:00:00 +0700
link: http://localhost
tags: first, second, third
categories: birds, fish
---

content one
EOT

# year changes to 2001 (since that one isn't as obvious)
POST_CONTENT_SECOND = <<EOT
title: second
time: 2001-01-01 00:00:00 +0700
link: http://127.0.0.1
tags: fourth, fifth, sixth
categories: dogs, cats
---

content two
EOT

class PostTest < Test::Unit::TestCase
  def test_sync
    file = Tempfile.new 'post'
    begin
      file.close false
      path = file.path
      
      IO.write file.path, POST_CONTENT_FIRST
      
      post = OakTree::Post.new file.path
      
      assert_equal post.title, 'first'
      assert_equal post.link, 'http://localhost'
      assert_equal post.tags, ['first', 'second', 'third']
      assert_equal post.categories, ['birds', 'fish']
      assert_equal post.time, DateTime.parse('2000-01-01 00:00:00 +0700')
      
      IO.write file.path, POST_CONTENT_SECOND
      
      assert_equal post.title, 'second'
      assert_equal post.link, 'http://127.0.0.1'
      assert_equal post.tags, ['fourth', 'fifth', 'sixth']
      assert_equal post.categories, ['dogs', 'cats']
      assert_equal post.time, DateTime.parse('2001-01-01 00:00:00 +0700')
      
    ensure
      file.unlink
    end
  end
end
