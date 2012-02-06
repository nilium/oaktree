require 'kramdown'
require 'kramdown/element'

class OakTree
  
  module Kramdown
    
    class OakHtml < ::Kramdown::Converter::Html
      
      def convert_footnote el, indent
        if @options[:auto_id_prefix]
          el.options[:name] = @options[:auto_id_prefix] + el.options[:name]
        end
        super
      end
      
      def convert_div el, indent
        "<#{el.type}#{html_attributes el.attr}>\n#{inner el, indent+1}\n</#{el.type}>"
      end
      
      def footnote_content
        return '' if @footnotes.empty?
        
        block = ::Kramdown::Element.new(:div, nil, {'class' => 'footnotes'})
        block.children << (list = ::Kramdown::Element.new(:ol))
        
        @footnotes.each { |fn_name, fn_elem|
          item = ::Kramdown::Element.new(:li, nil, {'id' => "fn:#{fn_name}"})
          # because we'll end up manipulating a child, we may as well do a deep copy
          item.children = Marshal.load(Marshal.dump(fn_elem.children))
          
          # basically what kramdown already does here
          last = (last = item.children.last).type == :p ? last : (::Kramdown::Element.new(:p))
          # yes, I'm using rev, shut up
          last.children << (anchor = ::Kramdown::Element.new(:a, nil, {'href' => "#fnref:#{fn_name}", 'rev' => 'footnote'}))
          anchor.children << ::Kramdown::Element.new(:raw, '&#8617;')

          list.children << item
        }
        
        convert(block, 2)
      end
      
    end
    
  end
  
end
