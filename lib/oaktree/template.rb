require 'mustache'
require 'date'

class OakTree
  
  module Template
    
    # Probably shouldn't do this, but it simplifies life.
    Mustache.template_path = 'template'
    
  end # Template
  
end # OakTree

