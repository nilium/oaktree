require 'date'
require 'fileutils'

require 'oaktree/specification'
require 'oaktree/post_data'

# The central blog class (also just called a tree from time to time)
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
      
      @posts << PostData.new(entry, blogspec)
      altered = true
    }

    return unless altered
    
    @posts.sort! { |left, right|
      right.time <=> left.time
    }
    
    return self
  end

end
