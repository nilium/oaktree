require 'date'
require 'fileutils'

# The enormous blog class
class OakTree
  
  VERSION = '0.0.1pre'

  def initialize spec
    @spec = spec

    @posts = []

    sync_posts
  end

  def blogspec
    @spec
  end

  private

  def sync_posts
    entries = Dir.glob("#{@spec.blog_root}/source/**/*.md")
    entries.each { |entry|
      @posts << Post.new(entry, self) unless @posts.index { |post| post.source_path === entry }
    }

    @posts.sort! { |left, right|
      left.time <=> right.time
    }
  end

end

require 'oaktree/specification'
require 'oaktree/post'
require 'oaktree/template'
