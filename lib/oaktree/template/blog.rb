require 'mustache'
require 'date'
require 'oaktree/template/base'
require 'oaktree/template/post'
require 'oaktree/template/post_archive'

class OakTree
  
  module Template
    
    class Blog < Base
      
      @@MODES = [:home, :archive, :single].freeze
      
      # returns an enumerator for all modes supported by the template class
      def self.modes
        @@MODES.each
      end
      
      # returns an enumerator for all modes supported by the template
      def modes
        Blog.modes
      end
  
      self.template_file = 'template/blog.mustache'
      
      def initialize tree, options = {}
        @tree = tree
        @spec = tree.blogspec
        @page_index = 0
        @mode = options[:mode] || :home
        raise "Invalid mode" unless @@MODES.include? @mode
    
        postdata = tree.posts
        @posts = postdata.map { |post|
          Post.new(@spec, post)
        }
        @posts.freeze
        
        # build the archive
        @archive = []
        @posts.each { |post|
          data = post.post_data
          time = data.time
        
          arch = @archive.last
          if arch.nil? || arch.year != time.year || arch.month != time.month
            arch = PostArchive.new(time.year, time.month, [], @spec, self) { |a|
              a.next_archive = arch
              arch.previous_archive = a unless arch.nil?
            }
            @archive << arch
          end
        
          arch.posts << post
        }
        @archive.freeze
        
        page = options[:page]
        page = page.nil? ? 0 : page - 1
        @page_index = page
      end
      
      def mode= mode
        raise "Invalid mode" unless @@MODES.include? mode
        @mode = mode
      end
    
      ### blog tags
      
      @@POST_DATE_PATH = '/%Y/%-m'
      
      def local_path
        path = @spec.blog_root + "/public"
        
        if home? && @page_index == 0
          path << "/index.html"
        else
          path << @spec.post_path
        
          case @mode
            when :home
              path << "/#{@page_index}.html"
            when :single
              data = post.post_data
              path << "#{data.time.strftime(@@POST_DATE_PATH)}/#{data.slug}.html"
            when :archive
              arch = @archive[@page_index]
              archdate = DateTime.new(arch.year, arch.month, 1)
              path << "#{archdate.strftime(@@POST_DATE_PATH)}.html"
          end
        end
        
        path
      end
      
      def blog_title
        @spec.title
      end
    
      def blog_author
        @spec.author
      end
  
      def blog_description
        @spec.description
      end
  
      def blog_url
        @spec.base_url
      end
    
      ### page tags
  
      def archive?
        @mode == :archive
      end
  
      def single?
        @mode == :single
      end
  
      def home?
        @mode == :home
      end
  
      # uses the input as a format string for the first day of the month and year
      # of the archive page.
      # this returns nil if not in archive mode.
      def archive_date
        return nil unless archive?
    
        arch = @archive[@page_index]
        proc_for_datetime(DateTime.new(arch.year, arch.month, 1))
      end
    
      # returns the number of pages
      def pages
        case @mode
          # you can render multiple home pages, but it's not something I recommend
          # since re-syncing all homepage posts is a nightmare at some point
          when :home
            (@posts.length / @spec.posts_per_page) + 1

          when :archive
            @archive.length

          when :single
            @posts.length
        end
      end
    
      # returns the current page number
      def page
        @page_index + 1
      end
    
      def page= page_num
        @page_index = (page_num - 1)
      end
      
      def paged?
        has_previous? || has_next?
      end
    
      # determines whether there's a previous page.  previous also means older.
      def has_previous?
        self.page < self.pages
      end
      
      # determines whether there is a next page.  next also means newer.
      def has_next?
        1 < self.page
      end
      
      def next_url
        return "" unless has_next?
        
        case @mode
          when :home
            if @page_index == 1
              blog_url
            else
              blog_url + @spec.post_path + "/#{@page_index - 1}.html"
            end
          when :archive
            @archive[@page_index - 1].permalink
          when :single
            @posts[@page_index - 1].permalink
        end
      end
      
      def previous_url
        return "" unless has_previous?
        
        case @mode
          when :home
            blog_url + @spec.post_path + "/#{@page_index + 1}.html"
          when :archive
            @archive[@page_index + 1].permalink
          when :single
            @posts[@page_index + 1].permalink
        end
      end
      
      ### archive tags
      
      def archives
        @archive
      end
      
      # the current archive
      def archive
        @archive[@page_index] if archive?
      end
    
      ### post tags
  
      # returns all visible posts
      # note: visible means whatever is in the current page
      def posts
        case @mode
          when :home
            page_start = @page_index * 10
            page_end = page_start + 10
            if @posts.length < page_end
              page_end = @posts.length
            end
    
            return [] unless page_start < @posts.length
    
            @posts[page_start .. page_end]
    
          when :archive
            @archive[@page_index].posts
        
          when :single
            [@posts[@page_index]]
        end
      end
    
      # if there's only one post being displayed, this returns its template.
      # only works in single mode.
      def post
        single? ? @posts[@page_index] : nil
      end
      
      # returns the next post (you generally shouldn't use this except to get
      # some small bit of info about the next post).
      # only works in single mode.
      def next_post
        single? && has_next? ? @posts[page_index - 1] : nil
      end
      
      # returns the previous post.
      # only works in single mode.
      def previous_post
        single? && has_previous? ? @posts[page_index + 1] : nil
      end
      
      def next_archive
        archive? && has_next? ? @archive[page_index - 1] : nil
      end
      
      def previous_archive
        archive? && has_previous? ? @archive[page_index + 1] : nil
      end
    
      ### general tags
    
      # treats the input text as a format string for today's date and time
      def today
        proc_for_datetime(DateTime.now)
      end
      
    end # Blog
    
  end # Template
  
end # OakTree
