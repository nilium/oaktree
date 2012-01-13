require 'test/unit'
require 'oaktree'

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
    tempfile = "post.temp.#{DateTime.now.strftime '%F_%Q'}.md"

    begin

      File.open(tempfile, 'w') { |io|
        io.write POST_CONTENT_FIRST
      }

      post = OakTree::Post.new tempfile

      assert_equal 'first', post.title
      assert_equal 'http://localhost', post.link
      assert_equal ['first', 'second', 'third'], post.tags
      assert_equal ['birds', 'fish'], post.categories
      assert_equal DateTime.parse('2000-01-01 00:00:00 +0700'), post.time

      File.open(tempfile, 'w') { |io|
        io.write POST_CONTENT_SECOND
      }

      assert_equal 'second', post.title
      assert_equal 'http://127.0.0.1', post.link
      assert_equal ['fourth', 'fifth', 'sixth'], post.tags
      assert_equal ['dogs', 'cats'], post.categories
      assert_equal DateTime.parse('2001-01-01 00:00:00 +0700'), post.time

    ensure

      File.unlink tempfile

    end
  end
end
