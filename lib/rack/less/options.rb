module Rack::Less
  class Options
    
    DEFAULT = {
      :hosted_root => '/stylesheets',
      :source_root => 'app/stylesheets',
      :concat      => {},
      :compress    => false
    }
    
    def initialize(options={})
      DEFAULT.keys.each do |option|
        instance_variable_set("@#{option}", options[option] || DEFAULT[option])
      end
    end
    
    # TODO: change to a set :option, value style
    DEFAULT.keys.each do |option|
      define_method("#{option}") { |value|
        if value
          instance_variable_set("@#{option}", value)
        else
          instance_variable_get("@#{option}")
        end
      }
    end
    
  end
end