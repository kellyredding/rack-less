require 'less'

module Rack::Less

  # The engine for compiling LESS CSS
  # Given the name of the less source file you want
  # to compile and a path to the source files,
  # will returns corresponding compiled LESS CSS
  class Source
    
    # prefer source files with the .less extension
    # but also accept files with the .css extension
    PREFERRED_EXTENSIONS = [:less, :css]
    
    attr_reader :css_name
    
    def initialize(css_name, options={})
      @css_name = css_name
      @compress = options[:compress]
      @cache    = options[:cache]
      @folder   = get_required_path(options, :folder)
      @combine  = options[:combine] || {}
    end
    
    def compress?
      !!@compress
    end
    def cache?
      !@cache.nil?
    end
    
    # Use named css sources before using combine directive sources
    def files
      @files ||= (css_sources.empty? ? combined_sources : css_sources)
    end
    
    def compiled
      @compiled ||= begin
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
    alias_method :to_css, :compiled
    alias_method :css, :compiled
    
    protected
    
    # Preferred, existing source files matching the css name
    def css_sources
      @css_sources ||= preferred_sources([@css_name])
    end
    
    # Preferred, existing source files matching a corresponding
    # combine directive, if any
    def combined_sources
      @combined_sources ||= preferred_sources(@combine[@css_name] || [])
    end
    
    private
    
    # Given a list of file names, return a list of
    # existing source files with the corresponding names
    # honoring the preferred extension list
    def preferred_sources(file_names)
      file_names.collect do |name|
        PREFERRED_EXTENSIONS.inject(nil) do |source_file, extension|
          source_file || begin
            path = File.join(@folder, "#{name}.#{extension}")
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
