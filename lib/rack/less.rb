require 'rack'
require 'rack/less/config'
require 'rack/less/base'
require 'rack/less/options'
require 'rack/less/request'
require 'rack/less/response'
require 'rack/less/source'

# === Usage
#
# Create with default configs:
#   require 'rack/less'
#   Rack::Less.new(app, :compress => true)
#
# Within a rackup file (or with Rack::Builder):
#   require 'rack/less'
#
#   use Rack::Less,
#     :source   => 'app/less'
#     :compress => true
#
#   run app

module Rack::Less
  MIME_TYPE = "text/css"
  @@config = Config.new
  
  class << self
    
    # Configuration accessors for Rack::Less
    # (see config.rb for details)
    def configure
      yield @@config if block_given?
    end
    def config
      @@config
    end
    def config=(value)
      @@config = value
    end
    
    # Combinations config convenience method
    def combinations(key=nil)
      @@config.combinations(key)
    end
    
    # Cache bust config convenience method
    def cache_bust
      @@config.cache_bust
    end

    # <b>DEPRECATED:</b> Please use <tt>cache_bust</tt> instead.
    def combination_timestamp
      warn "[DEPRECATION] `combination_timestamp` is deprecated.  Please use `cache_bust` instead."
      cache_bust
    end
    
  end

  # Create a new Rack::Less middleware component 
  # => the +options+ Hash can be used to specify default configuration values
  # => (see Rack::Less::Options for possible key/values)
  def self.new(app, options={}, &block)
    Base.new(app, options, &block)
  end
  
end
