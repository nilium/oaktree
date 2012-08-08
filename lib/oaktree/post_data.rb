require 'date'
require 'digest'
require 'psych'

class OakTree ; end


# Contains the contents of a single post under the sources/ directory. Unlike
# past versions of PostData, this does not synchronize with the source file
# every time a member is accessed. It's assumed that what you got when you
# loaded the post is what you wanted and that any further changes must be
# explicitly synchronized.
#
class OakTree::PostData

  attr_accessor :source_path
  # The path to the HTML file that's written when compiling the post.
  attr_accessor :public_path
  attr_accessor :title
  attr_accessor :link
  attr_accessor :permalink
  attr_reader :time
  # The post's slug, a filesystem- and URL-friendly string.
  attr_reader :slug
  # The post's body -- that is, the actual content of the blog post.
  attr_accessor :content
  # The time when the file was last read. Used to determine if sync_changes will
  # reload the file. Defaults to the Unix epoch.
  attr_accessor :last_read_time
  # The kind of post this is. Expected to be either :post or :static, though
  # the value is arbitrary.
  attr_reader :kind
  # The post's status. Either :published or :unpublished, though only :published
  # holds meaning -- other values are assumed to be unpublished.
  attr_reader :status
  attr_accessor :hash
  attr_accessor :spec

  protected :source_path=, :public_path=, :title=, :link=, :content=,
            :last_read_time=, :hash=, :spec=, :permalink=

  # Loads a new post from the source file using the given Specification. The
  # source file should be the full filename of the source file, but without any
  # other path components.
  #
  def initialize(source_name, spec)
    set_post_defaults

    self.spec = spec

    self.hash = nil
    self.last_read_time = Time.at(0).to_datetime

    self.source_path = File.absolute_path(source_name,
                                          spec.sources_root).freeze()

    raise "File doesn't exist: #{@source_path}"  if ! File.exists? @source_path

    sync_changes true
  end # initialize

  # Returns the default 'kind' a post should be. Typically means :post, though
  # it may change in the future.
  #
  def self.default_kind
    :post
  end

  # Returns the default 'status' a post should have. Typically :published, but
  # this may change in the future.
  #
  def self.default_status
    :published
  end

  # The regexp for identifying the line that separates the post head from the
  # post body. This is typically three or more hyphens.
  def self.metadata_separator
    /^-{3,}\s*$/
  end

  #   Synchronizes changes between the post's file and the post data object. If
  #   'forced' is true (or non-false/nil), it will reload the file regardless of
  #   whether it's considered necessary.
  #
  #   A "necessary" reload is when the file's hash changes or the file's last
  #   modification time is more recent than what the post data last read.
  #
  def sync_changes(forced = false)
    raise "Source file does not exist."  unless File.exists? @source_path

    source_differs  = !! forced
    source_mtime    = File.mtime(@source_path).to_datetime()
    source_contents = File.open(@source_path, 'r') { |io| io.read }
    source_hash     = Digest::SHA1.hexdigest(source_contents).freeze()

    if ! forced
      # Check that the source differs from what was last checked.
      source_differs = (hash != source_hash)
      public_exists  = (@public_path && File.exists?(@public_path))

      # Check if the public file is older than the current source file.
      if ! source_differs && public_exists
        public_mtime = File.mtime(@public_path).to_datetime()

        source_differs = true  if public_mtime < source_mtime
      end

      if ! source_differs && @last_read_time < source_mtime
        source_differs = true
      end
    end # ! forced

    return  if ! source_differs

    self.last_read_time = source_mtime

    # Reset the post's members to an unloaded state
    set_post_defaults
    self.hash = source_hash

    source_split = source_contents.partition(self.class.metadata_separator)

    load_header source_split[0]
    self.content = source_split[2]

    self
  end # sync_changes

  protected

  # The regular expression used to fix post slugs. Basically matches groups of
  # non-alphanumeric characters. This is used to replace slug-unfriendly chunks
  # of new slugs with slug word separators.
  #
  def self.slug_fix_regexp
    %r{(?:[^[:alnum:]] | [[:space:]])+}x
  end

  # Sets the default values for the post's data-related instance variables, so
  # anything loaded during synchronization gets reset by this. Includes the
  # post title, date, status, etc.
  #
  def set_post_defaults
    self.public_path = nil
    self.title       = nil
    self.link        = nil
    self.permalink   = nil
    self.time        = nil
    self.slug        = ''.freeze()

    self.kind        = self.class.default_kind
    self.status      = self.class.default_status
  end # set_post_defaults

  # Reads the header from the header_source string into the post data. Currently
  # uses Psych to parse the header as YAML.
  #
  def load_header(header_source)
    header_hash = Psych.load(header_source)

    header_hash.each {
      |key, value|
      setter_sym = :"#{key}="
      if self.respond_to?(setter_sym)
        self.send setter_sym, value
      else
        raise "Invalid key/value for header: #{key} => #{value}."
      end
    }

    self.slug = title  if ! slug || slug.empty?

    # Set the public HTML path and the permalink now that we have enough info
    # about the post.
    root = @spec.blog_root
    url = @spec.base_url

    link_path = ""
    link_path << @time.strftime(spec.date_path_format)  if kind == :post
    link_path << slug

    self.public_path = "#{root}/public/#{link_path}/index.html".freeze()
    self.permalink = "#{url}/#{link_path}"

    nil
  end # load_header

  # Assigns a new time to the post -- the time must be a DateTime object or a
  # String capable of being parsed by DateTime.parse.
  def time=(new_time)
    @time = if new_time
              case new_time.class
              when DateTime ; new_time
              when String ; DateTime.parse new_time
              else new_time.to_datetime
              end
            else
              Time.at(0).to_datetime
            end
  end

  # Sets the post slug, ensuring it's formatted properly.
  def slug=(new_slug)
    slug_temp = new_slug
    if slug_temp
      slug_temp = String.new(new_slug)
      slug_temp.strip!

      unless slug_temp.empty?
        slug_temp.downcase!
        slug_temp.gsub!(self.class.slug_fix_regexp, @spec.slug_separator)
      end
    else
      slug_temp = ''
    end

    @slug = slug_temp.freeze()
  end # slug=

  def kind=(new_kind)
    @kind = new_kind.to_sym
  end

  def status=(new_status)
    @status = new_status.to_sym
  end

end
