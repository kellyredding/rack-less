module Rack::Less
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
      @cache == true
    end
    
    def compress?
      @compress == true
    end
    
    # TODO: write custom :combinations reader and test it
    
  end
end