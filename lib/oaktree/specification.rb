require 'date'

class OakTree

  # Specifications for the blog, operates similar to Gem::Specification.
  # URLs and paths are strings and should not end in a slash.
  class Specification
    @@KEY_VALUE_PATTERN = /^\s*(?<key>[\w_]+)\s*:\s*(?<value>.*?)\s*(#|$)/
    @@DEFAULT_DATE_PATH_FORMAT = '%Y/%m/'
    @@DEFAULT_SLUG_SEPARATOR = '_'

    def self.default_date_path_format
      @@DEFAULT_DATE_PATH_FORMAT
    end

    def self.default_slug_separator
      @@DEFAULT_SLUG_SEPARATOR
    end

    # The blog's title
    attr_accessor :title
    # A description of the blog
    attr_accessor :description
    # The blog root, where files are stored locally.
    # Beneath this directory, there should be /source and /public directories,
    # where post sources and the blog output, respectively, are stored. If these
    # don't exist, they'll be created when generating the blog.
    # This cannot be changed.
    attr_reader :blog_root
    # The name of the blog's author (currently assumes a single author)
    attr_accessor :author
    # The number of posts displayed per page
    attr_accessor :posts_per_page
    # Whether the timeline is reversed
    attr_accessor :reversed
    # The date format for post paths
    attr_accessor :date_path_format
    # The separator for words in slugs. May not be whitespace if loaded from a
    # blog_spec file.
    attr_accessor :slug_separator

    # Sets the post path (i.e., the subdirectory where posts are stored).
    # Should not begin with a slash, but can have a trailing slash if you want.
    # If there is no trailing slash, it will be part of the filename up to a
    # a point.
    def post_path= path
      raise "post_path provided is nil" if path.nil?
      raise "post_path provided is not a string" unless path.kind_of?(String)

      @post_path = path.clone().freeze()
    end

    # Gets the post path (i.e., the subdirectory where posts are stored).
    def post_path
      @post_path
    end

    def date_path_format= format
      if format.empty?
        @date_path_format = self.class.default_date_path_format
      else
        @date_path_format = format
      end
    end

    # Sets the base URL of the blog (i.e., http://localhost/blog) - should have
    # a trailing slash.
    def base_url= url
      url = String.new(url)
      url << '/'  unless url.end_with? '/'
      @base_url = url.freeze()
    end

    # Gets the base URL of the blog (i.e., http://localhost/blog).
    def base_url
      @base_url
    end

    def sources_root
      @sources_root ||= "#{@blog_root}/source"
    end

    # Loads a specification from a file.
    def self.from_file(path)
      raise "Spec file does not exist" unless File.exists? path

      self.new { |spec|

        spec_contents = File.open(path, 'r') { |io| io.read }
        spec_hash = Psych.load(spec_contents)
        spec_hash.each {
          |key, value|
          setter_sym = :"#{key}="
          if spec.respond_to? setter_sym
            spec.send setter_sym, value
          else
            raise "Invalid key/value in spec: #{key} => #{value}"
          end
        }

        Dir.chdir(File.dirname(path))

      }
    end

    # Initializes the Specification with its default values.
    def initialize
      # initialize default values for most properties
      self.title = ''
      self.description = ''
      self.base_url = ''
      self.post_path = 'post/'
      self.author = ''
      self.posts_per_page = 10
      self.reversed = false
      self.date_path_format = self.class.default_date_path_format
      self.slug_separator = self.class.default_slug_separator

      yield self if block_given?

      @blog_root = File.expand_path Dir.getwd
    end

    def export_string
      <<-EOT
# metadata
title:  #{@title}
description: #{@description}
author: #{@author}
posts_per_page: 10

# public URL
base_url:  #{@base_url}

# public content paths
post_path: #{@post_path}
      EOT
    end

  end # Specification

end # OakTree
