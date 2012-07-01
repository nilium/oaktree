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

  VERSION = '0.2.1'

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

    skipped_files = []
    new_files = []
    updated_files = []
    old_files = Dir.glob('public/**/*.html')

    blog_template.modes.each {
      |mode|

      blog_template.mode = mode

      (1..blog_template.pages).each { |page|
        blog_template.page = page
        path = blog_template.local_path
        pretty_path = Pathname.new(path).relative_path_from(Pathname.new(@spec.blog_root)).to_s

        if old_files.include? pretty_path
          old_files.delete pretty_path
        end

        mtime = File.exists?(path) ? File.mtime(path) : nil
        needs_update = force_build || mtime.nil?

        if ! needs_update
          needs_update = blog_template.posts.inject(false) { |memo, post|
            data = post.post_data
            memo || mtime < data.file_mtime
          }

          if ! needs_update
            skipped_files << path
            next
          end
        end

        dir = File.dirname(path)
        FileUtils.mkdir_p dir unless File.directory? dir

        if File.exists? path
          updated_files << pretty_path
        else
          new_files << pretty_path
        end

        File.open(path, 'w') {
          |io|
          io.write blog_template.render
        }
      }
    }

    updated_files.each { |path| puts "* #{path}" }

    new_files.each { |path| puts "+ #{path}"}

    old_files.each {
      |path|
      puts "- #{path}"
      File.unlink path
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
      @spec.reversed ? left.time <=> right.time : right.time <=> left.time
    }

    return self
  end

end
