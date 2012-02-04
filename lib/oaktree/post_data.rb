require 'digest'

class OakTree; end

class OakTree::PostData
  @@METADATA_SEPARATOR = /^-{3,}\s*$/
  @@METADATA_ITEM = /^\s*(?<key>\w+)\s*:\s*(?<value>.*?)\s*$/
  
  attr_reader :source_path
  
  # The path to the public generated HTML file
  @public_path = nil
  # The path to the private source MD file
  @source_path = ''
  
  @title = nil
  @time = nil       # DateTime the post displays
  @slug = nil       # Post slug (generated by default, but can be specified)
  @link = nil       # A link the post leads to other than its own permalink
  
  @categories = []
  @tags = []
  
  @spec = nil
  @md5 = ''
  
  # Optionally takes an OakTree::Specification object as the spec.
  def initialize path, spec = nil
    @last_modified = DateTime.now
    @source_path = path
    @spec = spec
    
    sync_changes true
  end
  
  def public_path
    sync_changes
    @public_path
  end
  
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
  
  def slug
    sync_changes
    @slug
  end
  
  def content
    sync_changes
    @content
  end
  
  def last_modified
    sync_changes
    @last_modified
  end
  
  private
  
  def sync_changes force = false
    raise "Source file '#{@source_path}' does not exist" unless File.exists? @source_path
    
    cur_md5 = Digest::MD5.hexdigest File.open(@source_path, 'r') { |io| io.read }
    
    if not force then
      # check if the source differs from what was last checked
      sources_differ = !(cur_md5 === @md5)
      # also check if the public HTML is older than the source (meaning the
      # public HTML needs to be regenerated, probably)
      sources_differ = (sources_differ || File.mtime(@public_path) < File.mtime(@source_path)) if File.exists? @public_path
      
      return unless sources_differ
    end
    
    source = File.open(@source_path, 'r') { |io| io.read }
    source_split = source.rpartition @@METADATA_SEPARATOR
    @md5 = cur_md5
    
    @slug = nil
    @categories = []
    @tags = []
    @link = ''
    @title = nil
    @time = nil
    @content = nil
    
    split_index = 0
    
    source_split[0].lines.each { |line|
      match = line.match @@METADATA_ITEM
      
      if match.nil? then
        next
      end
      
      key = match[:key]
      value = match[:value]
      
      case key.to_sym
        when :title
          @title = value.freeze
          
        when :time
          @time = DateTime.parse(value).freeze
          
        when :link
          @link = value.freeze
          
        when :tags
          @tags = value.split(',').map { |item| item.strip.freeze } .freeze
          
        when :categories
          @categories = value.split(',').map { |item| item.strip.freeze } .freeze
          
        when :slug
          @slug = value.freeze
          
        else
          puts "Unrecognized metadata key '#{key}' in #{@source_path}"
      end
    }
    
    raise "No title provided in post '#{@source_path}'" if @title.nil?
    raise "No post time provided in post '#{@source_path}'" if @time.nil?
    
    if @slug.nil? then
      @slug = @title.gsub(/[\n\t]+/, '').strip.gsub(/[^_\w\s]/, '').strip.gsub(/\s+/, '_').downcase
    end
    
    @content = source_split[2]
    
    @public_path = "public/#{@time.strftime '%Y/%m'}/#{@slug}.html"
    @public_path = "#{@spec.blog_root}/#{@public_path}" unless @spec.nil?
    
    @last_modified = DateTime.now
  end
end