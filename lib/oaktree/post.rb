class OakTree::Post
  @@METADATA_SEPARATOR = /^-{3,}\s*$/
  @@METADATA_ITEM = /^\s*(?<key>\w+)\s*:\s*(?<value>.*?)\s*$/
  
  attr_reader :source_path
  
  def title
    sync_changes
    @title
  end
  
  def link
    sync_changes
    @link
  end
  
  def time
    sync_changes
    @time
  end
  
  def tags
    sync_changes
    @tags
  end
  
  def categories
    sync_changes
    @categories
  end
  
  def initialize path, blog = nil
    @source_path = path
    
    @slug = nil
    @title = ''
    @link = ''
    @time = DateTime.now
    @tags = []
    @categories = []
    
    @last_modified = Time.at 0
    
    sync_changes
  end
  
  def mtime
    @last_modified
  end
  
  def slug
    if @slug.nil? then
      slug_title = @title.gsub(/[^\w\s_]+/, '').strip.gsub(/[\s_]+/, '_')
      @slug = "#{@time.strftime '%Y-%M-%d'}_#{slug}"
    end
    
    return @slug
  end
  
  def force_sync
    @last_modified = Time.at 0
    self.sync_changes
  end
  
  private
  
  def sync_changes
    modified_time = File.mtime @source_path
    
    return if modified_time < @last_modified
    
    source = IO.read @source_path
    @last_modified = modified_time
    
    source.lines.each { |line|
      break if line =~ @@METADATA_SEPARATOR
      
      match = line.match @@METADATA_ITEM
      
      if match.nil? then
        puts "Unmatched line: '#{line}' in #{@source_path}"
        next
      end
      
      key = match[:key]
      value = match[:value]
      
      case key.to_sym
        when :title
          @title = value.freeze
          @slug = nil
        when :time
          @time = DateTime.parse(value).freeze
          @slug = nil
        when :link
          @link = value.freeze
        when :tags
          @tags = value.split(',').map { |item| item.strip.freeze } .freeze
        when :categories
          @categories = value.split(',').map { |item| item.strip.freeze } .freeze
        else
          puts "Unrecognized metadata key '#{key}' in #{@source_path}"
      end
    }
  end
end
