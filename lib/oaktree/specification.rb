require 'date'

class OakTree; end

# Specifications for the blog, operates similar to Gem::Specification.
# URLs and paths are strings and should not end in a slash.
class OakTree::Specification
  @@KEY_VALUE_PATTERN = /^\s*(?<key>[\w_]+)\s*:\s*(?<value>.*?)\s*(#|$)/
  
  # The blog's title
  attr_accessor :title
  # A description of the blog
  attr_accessor :description
  # The base URL of the blog (i.e., http://localhost/blog) - should not have a
  # trailing slash.
  attr_accessor :base_url
  # The post path (i.e., the subdirectory where posts are stored).
  attr_accessor :post_path
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
    self.title = 'Title'
    self.description = 'A brief description of this blog'
    self.base_url = 'http://localhost'
    self.post_path = 'post'
    self.author = "Someone"
    self.posts_per_page = 10
    
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
end
