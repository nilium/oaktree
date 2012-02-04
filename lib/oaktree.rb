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
  
  def posts
    sync_posts
    return @posts
  end

  private

  def sync_posts
    entries = Dir.glob("#{@spec.blog_root}/source/**/*.md")
    altered = false
    entries.each { |entry|
      next if @posts.index { |post| post.source_path === entry }
      
      @posts << Post.new(entry, self)
      altered = true
    }

    return unless altered
    
    @posts.sort! { |left, right|
      left.time <=> right.time
    }
    
    return self
  end

end

require 'oaktree/specification'
require 'oaktree/post'
require 'oaktree/template'
