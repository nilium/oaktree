require 'kramdown'
require 'oaktree/template'
require 'oaktree/kramdown/oak_html'

class OakTree

  module Template

    class Post < Base

      self.template_file = 'template/post.mustache'

      def initialize spec, post
        @post = post
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

      def static?
        @post.kind == :static
      end

      def post?
        @post.kind == :post
      end

      def content
        if @content.nil?
          document = ::Kramdown::Document.new(@post.content)
          @content, warnings = ::OakTree::Kramdown::OakHtml.convert(document.root, :auto_id_prefix => @post.time.strftime('%Y_%m_%d_'))
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

      def published?
        @post.status == :published
      end

      def unpublished?
        ! published?
      end

      def status
        @post.status
      end

    end # Post

  end # Template

end # OakTree