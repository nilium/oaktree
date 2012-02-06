require 'kramdown'
require 'oaktree/template'
require 'oaktree/kramdown/oak_html'

class OakTree
  
  module Template
    
    class Post < Base
      
      self.template_file = 'template/post.mustache'
  
      def initialize spec, post
        @post = post
        @mtime = @post.last_modified
        @content = nil
        @spec = spec
      end
    
      def post_data
        @post
      end
  
      def title
        @post.title
      end
    
      def url
        if source_link?
          source_link
        else
          permalink
        end
      end
    
      def permalink
        @post.permalink
      end
  
      def source_link
        @post.link
      end
  
      def source_link?
        plink = @post.link
        ! (plink.nil? || plink.empty?)
      end
  
      def content
        if @content.nil? || @mtime < @post.last_modified
          document = Kramdown::Document.new(@post.content)
          @content, warnings = OakTree::Kramdown::OakHtml.convert(document.root, :auto_id_prefix => @post.time.strftime('%Y_%m_%d_'))
          puts warnings unless warnings.empty?
        end
    
        @content
      end
  
      def time
        proc_for_datetime(@post.time)
      end
  
      def public_path
        @post.public_path
      end
  
      def slug
        @post.slug
      end
  
      def tags
        @post.tags
      end
  
      def categories
        @post.categories
      end
      
    end # Post
    
  end # Template
  
end # OakTree