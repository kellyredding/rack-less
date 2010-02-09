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
    
    # configure Rack::Less (see config.rb for details)
    def configure
      yield @@config if block_given?
    end
    
    def config
      @@config
    end
    
    def config=(value)
      @@config = value
    end

  end

  # Create a new Rack::Less middleware component 
  # => the +options+ Hash can be used to specify default configuration values
  # => a block can given as an alternate method for setting option values (see example above)
  # => (see Rack::Less::Options for possible key/values)
  def self.new(app, options={}, &block)
    Base.new(app, options, &block)
  end
  
end
