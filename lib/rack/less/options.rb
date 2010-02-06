module Rack::Less
  module Options
    
    # Handles options and configuration for Rack::Less
    # Available options:
    # => source_root
    #    the path (relative to the app root) where
    #    LESS files are located
    # => hosted_at
    #    the public HTTP root path for stylesheets
    # => cache
    #    whether to cache the compilation output to a
    #    corresponding file in the hosted_root
    # => compress
    #    whether to remove extraneous whitespace from
    #    compilation output
    # => concat
    #    expects a hash containing directives for contactenating
    #    the ouput of one or more LESS compilations, for example:
    #    { 'app' => ['one', 'two', 'three']}
    #    will respond to a request for app.css with the concatenated
    #    output of compiling one.less, two.less, and three.less
    
    # Note: the following code is more or less a rip from:
    # => http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/options.rb
    # => thanks to rtomayko, I thought this approach was really smart and the credit is his.
    
    RACK_ENV_NS = "rack-less"
    
    module ClassMethods
      
      def defaults
        {
          option_name(:source_root) => 'app/stylesheets',
          option_name(:hosted_at)   => '/stylesheets',
          option_name(:cache)       => false,
          option_name(:compress)    => false,
          option_name(:concat)      => {}
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
      #module_function :option_name
      
      # The underlying options Hash. During initialization (or outside of a
      # request), this is a default values Hash. During a request, this is the
      # Rack environment Hash. The default values Hash is merged in underneath
      # the Rack environment before each request is processed.
      def options
        @env || @default_options
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
      def set(option, value=nil, &block)
        if block_given?
          write_option option, block
        elsif value.nil?
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