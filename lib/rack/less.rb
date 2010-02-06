require 'rack'
require 'rack/less/base'
require 'rack/less/options'
require 'rack/less/request'
require 'rack/less/response'

# === Usage
#
# Create with default configs:
#   require 'rack/less'
#   Rack::Less.new(app, :compress => true)
#
# Within a rackup file (or with Rack::Builder):
#   require 'rack/less'
#   use Rack::Less do |option|
#     option.compress     true
#     option.source_root  'app/less'
#   end
#   run app

module Rack::Less

  # Create a new Rack::Less middleware component 
  # => the +options+ Hash can be used to specify default configuration values
  # => a block can given as an alternate method for setting option values (see example above)
  # => (see Rack::Less::Options for possible key/values)
  def self.new(app, options={}, &block)
    Base.new(app, options, &block)
  end
  
end
