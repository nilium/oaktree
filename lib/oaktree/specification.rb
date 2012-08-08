require 'date'

class OakTree

  # Specifications for the blog, operates similar to Gem::Specification.
  # URLs and paths are strings and should not end in a slash.
  class Specification
    @@KEY_VALUE_PATTERN = /^\s*(?<key>[\w_]+)\s*:\s*(?<value>.*?)\s*(#|$)/
    @@DEFAULT_DATE_PATH_FORMAT = '%Y/%m/'
    @@DEFAULT_WORD_SEPARATOR = '_'

    def self.default_date_path_format
      @@DEFAULT_DATE_PATH_FORMAT
    end

    def self.default_word_separator
      @@DEFAULT_WORD_SEPARATOR
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
    attr_accessor :word_separator

    # Sets the post path (i.e., the subdirectory where posts are stored).
    # Should not have a trailing slash, but should have a beginning slash.
    def post_path= path
      raise "post_path provided is nil" if path.nil?
      raise "post_path provided is not a string" unless path.kind_of?(String)

      @post_path = path.chomp('/')
      @post_path = "/#{@post_path}" if ! @post_path.empty? && ! @post_path.start_with?('/')
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

    # Sets the base URL of the blog (i.e., http://localhost/blog) - should not
    # have a trailing slash.
    def base_url= url
      raise "base_url provided is nil" if url.nil?
      raise "base_url provided is not a string" unless url.kind_of?(String)

      @base_url = url.chomp('/')
    end

    # Gets the base URL of the blog (i.e., http://localhost/blog).
    def base_url
      @base_url
    end

    def sources_root
      @sources_root ||= "#{@blog_root}/sources"
    end

    # Loads a specification from a file.
    def self.from_file(path)
      raise "Spec file does not exist" unless File.exists? path

      self.new { |spec|

        File.open(path, 'r') { |io|

          io.each_line { |line|
            line = line.strip

            next if line.empty? || line.start_with?('#')

            match = line.match @@KEY_VALUE_PATTERN

            if match.nil? then
              puts "Invalid entry in blog_spec: #{line}"
              next
            end

            key = match[:key]
            value = match[:value]

            case key.to_sym
              when :title
                spec.title = value
              when :description
                spec.description = value
              when :base_url
                spec.base_url = value
              when :post_path
                spec.post_path = value
              when :author
                spec.author = value
              when :posts_per_page
                spec.posts_per_page = value.to_i
              when :reversed
                spec.reversed = value.downcase =~ /^(true|1|yes)$/ ? true : false
              when :date_path_format
                spec.date_path_format = value
              when :word_separator
                spec.word_separator = value
              else
                puts "Invalid name for entry in blog_spec: #{line}"
            end
          }

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
      self.post_path = '/post'
      self.author = ''
      self.posts_per_page = 10
      self.reversed = false
      self.date_path_format = self.class.default_date_path_format
      self.word_separator = self.class.default_word_separator

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
