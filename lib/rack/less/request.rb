require 'rack/request'

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

    def is_for_less_css?
      false
    end
  end
end
