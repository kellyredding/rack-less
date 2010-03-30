module Rack::Less
  module Options
    
    # Handles options for Rack::Less
    # Available options:
    # => root
    #    the app root. the reference point for the
    #    source and public options
    # => source
    #    the path (relative to the root) where
    #    LESS files are located
    # => public
    #    the path (relative to the root) where
    #    static files are served
    # => hosted_at
    #    the public HTTP root path for stylesheets
    
    # Note: the following code is heavily influenced by:
    # => http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/options.rb
    # => thanks to rtomayko, I thought his approach was really smart.
    
    RACK_ENV_NS = "rack-less"
    
    module ClassMethods
      
      def defaults
        {
          option_name(:root)      => ".",
          option_name(:source)    => 'app/stylesheets',
          option_name(:public)    => 'public',
          option_name(:hosted_at) => '/stylesheets'
        }
      end

      # Rack::Less uses the Rack Environment to store option values. All options
      # are stored in the Rack Environment as "<RACK_ENV_PREFIX>.<option>", where
      # <option> is the option name.
      def option_name(key)
        case key
        when Symbol ; "#{RACK_ENV_NS}.#{key}"
        when String ; key
        else raise ArgumentError
        end
      end
      
    end
    
    module InstanceMethods
      
      # Rack::Less uses the Rack Environment to store option values. All options
      # are stored in the Rack Environment as "<RACK_ENV_PREFIX>.<option>", where
      # <option> is the option name.
      def option_name(key)
        self.class.option_name(key)
      end
      
      # The underlying options Hash. During initialization (or outside of a
      # request), this is a default values Hash. During a request, this is the
      # Rack environment Hash. The default values Hash is merged in underneath
      # the Rack environment before each request is processed.
      # => if a key is passed, the option value for the key is returned
      def options(key=nil)
        if key
          (@env || @default_options)[option_name(key)]
        else
          @env || @default_options
        end
      end

      # Set multiple options at once.
      def options=(hash={})
        hash.each { |key,value| write_option(key, value) }
      end 

      # Set an option. When +option+ is a Symbol, it is set in the Rack
      # Environment as "rack-cache.option". When +option+ is a String, it
      # exactly as specified. The +option+ argument may also be a Hash in
      # which case each key/value pair is merged into the environment as if
      # the #set method were called on each.
      def set(option, value=nil)
        if value.nil?
          self.options = option.to_hash
        else
          write_option option, value
        end
      end

      private

      def initialize_options(options={})
        @default_options = self.class.defaults
        self.options = options
      end

      def read_option(key)
        options[option_name(key)]
      end

      def write_option(key, value)
        options[option_name(key)] = value
      end

    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
    
  end
end