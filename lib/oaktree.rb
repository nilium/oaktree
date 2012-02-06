require 'date'
require 'fileutils'
require 'pathname'

require 'oaktree/specification'
require 'oaktree/post_data'
require 'oaktree/template'

# Probably violating some rule on naming by calling this oaktree.rb instead of
# oak_tree.rb.  Oh well.

# The central blog class (also just called a tree from time to time)
class OakTree
  
  VERSION = '0.1.0'

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
  
  # Generates and writes the HTML files for the blog.
  # If force_rebuild is false, it will only rebuild pages with posts that have
  # changed, otherwise it rebuilds everything.
  # This does not check for changes to templates or other content -- if you
  # make any changes to templates, you must force a rebuild.
  def generate force_build = false
    blog_template = Template::Blog.new self
    
    blog_template.modes.each {
      |mode|
      
      blog_template.mode = mode
      
      (1..blog_template.pages).each { |page|
        blog_template.page = page
        path = blog_template.local_path
        pretty_path = Pathname.new(path).relative_path_from(Pathname.new(@spec.blog_root)).to_s
        
        mtime = File.exists?(path) ? File.mtime(path) : nil
        needs_update = force_build || mtime.nil?
        
        if ! needs_update
          needs_update = blog_template.posts.inject(false) { |memo, post|
            data = post.post_data
            memo || mtime < data.file_mtime
          }
          
          if ! needs_update
            puts "Skipping #{pretty_path}"
            next
          end
        end
        
        dir = File.dirname(path)
        FileUtils.mkdir_p dir unless File.directory? dir
        
        puts "Writing #{pretty_path}"
        File.open(path, 'w') {
          |io|
          io.write blog_template.render
        }
      }
    }
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
