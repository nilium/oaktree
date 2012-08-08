require 'date'
require 'mustache'
require 'oaktree/template'

class OakTree

  module Template
  
    class Base < Mustache
      DEFAULT_DATETIME_FORMAT = '%-d %B %Y @ %l:%M %p'
    
      def proc_for_datetime time
        proc { |format|
          format ||= DEFAULT_DATETIME_FORMAT
        
          render(time.strftime(format))
        }
      end
      
      self.template_path = 'template'

    end # Base

  end # Template

end # OakTree