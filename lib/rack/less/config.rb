module Rack::Less
  
  # Handles configuration for Rack::Less
  # Available config settings:
  # :cache
  #   whether to cache the compilation output to
  #   a corresponding static file. Also determines
  #   what value config#combinations(:key) returns
  # :compress
  #   whether to remove extraneous whitespace from
  #   compilation output
  # :combinations
  #   Rack::Less uses combinations as directives for
  #   combining the output of many stylesheets and
  #   serving them as a single resource.  Combinations
  #   are defined using a hash, where the key is the
  #   resource name and the value is an array of
  #   names specifying the stylesheets to combine
  #   as that resource.  For example:
  #     Rack::Less.config.combinations = {
  #       'web'    => ['reset', 'common', 'app_web'],
  #       'mobile' => ['reset', 'iui', 'common', 'app_mobile']
  #     }
  class Config
    
    ATTRIBUTES = [:cache, :compress, :combinations]
    attr_accessor *ATTRIBUTES
    
    DEFAULTS = {
      :cache        => false,
      :compress     => false,
      :combinations => {}
    }

    def initialize(settings={})
      ATTRIBUTES.each do |a|
        instance_variable_set("@#{a}", settings[a] || DEFAULTS[a])
      end
    end
    
    def cache?
      !!@cache
    end
    
    def compress?
      !!@compress
    end
    
    def combinations(key=nil)
      if key.nil?
        @combinations
      else
        cache? ? key : @combinations[key]
      end
    end
    
  end
end