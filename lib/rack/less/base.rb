require 'rack/less/options'
require 'rack/less/request'
require 'rack/less/response'

module Rack::Less
  class Base
    include Rack::Less::Options

    def initialize(app, options={})
      @app = app
      initialize_options options
      yield self if block_given?
      validate_options
    end

    # The Rack call interface. The receiver acts as a prototype and runs
    # each request in a clone object unless the +rack.run_once+ variable is
    # set in the environment.
    # ripped from: http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/context.rb
    def call(env)
      if env['rack.run_once']
        call! env
      else
        clone.call! env
      end
    end

    # The real Rack call interface.
    # if LESS CSS is being requested, this is an endpoint:
    # => generate the compiled css
    # => respond appropriately
    # Otherwise, call on up to the app as normal
    def call!(env)
      @default_options.each { |k,v| env[k] ||= v }
      @env = env
      
      if (@request = Request.new(@env.dup.freeze)).for_less?
        Response.new(@env.dup.freeze, @request.source.to_css).to_rack
      else
        @app.call(env)
      end
    end
    
    private
    
    def validate_options
      # ensure a root path is specified and does exists
      unless options.has_key?(option_name(:root)) and !options(:root).nil?
        raise(ArgumentError, "no :root option set")
      end
      set :root, File.expand_path(options(:root))

      # ensure a source path is specified and does exists
      unless options.has_key?(option_name(:source)) and !options(:source).nil?
        raise(ArgumentError, "no :source option set")
      end
    end
    
  end
end