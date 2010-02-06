require 'rack/less/options'
require 'rack/less/request'
require 'rack/less/response'

module Rack::Less
  class Base

    def initialize(app, options={})
      @app = app
      @options = Options.new(options)
      yield @options if block_given?
    end

    # making the code below thread safe by duplicating self on call.
    # => from http://railscasts.com/episodes/151-rack-middleware
    def call(env)
      dup._call(env)
    end
    def _call(env)
      # Get request headers
      # for 'text/css' requests only
      # check for corresponding less file in source root
      # check for corresponding concat config
      # build and run less appropriately
      # return appropriate response and such
      # otherwise call the app on up
      @app.call(env)
    end

  end
end