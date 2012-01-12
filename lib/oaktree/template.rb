class OakTree::Template
  attr_reader :root
  
  def new root
    raise "nil BlogSpec provided for Template" if blogspec.nil?
    
    @root = root
    @parts = {}
  end
  
  # Gets a Part 
  def load_part part_name
    part = self.get_part part_name
    
  end
  
  private
  
  def get_part part_name
  end
end

require 'oaktree/template/part'
