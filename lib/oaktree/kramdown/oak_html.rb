require 'kramdown'

class OakTree
  
  module Kramdown
    
    class OakHtml < ::Kramdown::Converter::Html
      
      def convert_footnote el, indent
        if @options[:auto_id_prefix]
          el.options[:name] = @options[:auto_id_prefix] + el.options[:name]
        end
        super
      end
      
    end
    
  end
  
end
