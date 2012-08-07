require 'oaktree/template/base'
require 'mustache'
require 'date'

class OakTree

  module Template

    class PostArchive < Base
      self.template_file = "template/postarchive.mustache"

      attr_accessor :year
      attr_accessor :month
      attr_accessor :posts
      # the next most recent archive
      attr_accessor :next_archive
      # the next oldest archive
      attr_accessor :previous_archive

      def initialize year=1, month=1, posts=[], spec, blog
        @year = year
        @month = month
        @posts = posts
        @spec = spec
        @blog = blog

        yield self if block_given?
      end

      def date
        proc_for_datetime(DateTime.new(year, month, 1))
      end

      def permalink
        @spec.base_url + @spec.post_path + "/#{year}/#{month}/"
      end

      def open?
        self == @blog.archive
      end

    end

  end

end