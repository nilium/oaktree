require 'mustache'
require 'date'

class OakTree
  
  module Template
    
    # Probably shouldn't do this, but it simplifies life.
    Mustache.template_path = 'template'
    
    autoload :Base, 'oaktree/template/base'
    autoload :PostArchive, 'oaktree/template/post_archive'
    autoload :Post, 'oaktree/template/post'
    autoload :Blog, 'oaktree/template/blog'
    
  end # Template
  
end # OakTree

