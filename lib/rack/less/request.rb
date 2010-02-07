require 'rack/request'
require 'rack/less/options'
require 'rack/less/source'

module Rack::Less

  # Provides access to the HTTP request.
  # Request objects respond to everything defined by Rack::Request
  # as well as some additional convenience methods defined here
  # => from: http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/request.rb

  class Request < Rack::Request

    # The HTTP request method. This is the standard implementation of this
    # method but is respecified here due to libraries that attempt to modify
    # the behavior to respect POST tunnel method specifiers. We always want
    # the real request method.
    def request_method
      @env['REQUEST_METHOD']
    end
    
    def path_info
      @env['PATH_INFO']
    end

    # Determine if the request is for existing LESS CSS file
    # This will be called on every request so speed is an issue
    # => first check if the request is for a css file (fast)
    # => then check for less source files that match the request (slow)
    def for_less?
      p "req: #{self.path_info}"
      # for_css? && !engine.files.empty?
      false
    end
    
    # TODO: get this going
    # Determine if the request is for a css file
    def for_css?
    end
    
    def source
      # TODO: setup env stuff to init Source class
      #@source ||= Source.new(self.dup)
    end

  end
end
