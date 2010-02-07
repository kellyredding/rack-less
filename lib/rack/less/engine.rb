require 'less'

module Rack::Less

  # The engine for compiling LESS CSS
  # Given the name of the css you want to compile
  # and a path the the sources files, call .to_css
  # to return corresponding compiled LESS CSS
  class Engine
    
    # prefer source files with the .less extension
    # but also accept files with the .css extension
    PREFERRED_EXTENSIONS = [:less, :css]
    
    attr_reader :css_name
    
    def initialize(css_name, options={})
      @css_name = css_name
      @concat   = options[:concat] || {}
      @compress = options[:compress]
      @cache    = options[:cache]

      @source_path = get_required_path(options, :source_path)
    end
    
    def compress?
      !!@compress
    end
    def cache?
      !@cache.nil?
    end
    
    # Use named css sources before using concat directive sources
    def files
      @files ||= (css_sources.empty? ? concat_sources : css_sources)
    end
    
    def to_css
      @css ||= begin
        compiled_css = files.collect do |file_path|
          Less::Engine.new(File.new(file_path)).to_css
        end.join("\n")
        
        compiled_css.delete!("\n") if compress?
        if cache? && !File.exists?(cf = File.join(@cache, "#{@css_name}.css"))
          FileUtils.mkdir_p(@cache)
          File.open(cf, "w") do |file|
            file.write(compiled_css)
          end
        end
        
        compiled_css
      end
    end
    alias_method :css, :to_css
    
    protected
    
    # Preferred, existing source files matching the css name
    def css_sources
      @css_sources ||= preferred_sources([@css_name])
    end
    
    # Preferred, existing source files matching a corresponding
    # concat directive, if any
    def concat_sources
      @concat_sources ||= preferred_sources(@concat[@css_name] || [])
    end
    
    private
    
    # Given a list of file names, return a list of
    # existing source files with the corresponding names
    # honoring the preferred extension list
    def preferred_sources(file_names)
      file_names.collect do |name|
        PREFERRED_EXTENSIONS.inject(nil) do |source_file, extension|
          source_file || begin
            path = File.join(@source_path, "#{name}.#{extension}")
            File.exists?(path) ? path : nil
          end
        end
      end.compact
    end
    
    def get_required_path(options, path_key)
      unless options.has_key?(path_key)
        raise(ArgumentError, "no :#{path_key} option specified")
      end
      unless File.exists?(options[path_key])
        raise(ArgumentError, "the :#{path_key} ('#{options[path_key]}') does not exist") 
      end
      options[path_key]
    end
    
  end
  
end
