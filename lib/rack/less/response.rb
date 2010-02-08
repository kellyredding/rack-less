require 'rack/response'
require 'rack/utils'

module Rack::Less

  # Given some generated css, mimicks a Rack::Response
  # => call to_rack to build standard rack response parameters
  class Response
    include Rack::Less::Options
    include Rack::Response::Helpers

    # Rack response tuple accessors.
    attr_accessor :status, :headers, :body
    
    class << self

      # Calculate appropriate content_length
      def content_length(body)
        if body.respond_to?(:bytesize)
          body.bytesize
        else
          body.size
        end
      end
      
    end

    # Create a Response instance given the env
    # and some generated css.
    def initialize(env, css)
      @env = env
      @body = css
      @status = 200 # OK
      @headers = Rack::Utils::HeaderHash.new

      headers["Content-Type"] = Rack::Less::MIME_TYPE
      headers["Content-Length"] = self.class.content_length(body).to_s
    end
    
    def to_rack
      [status, headers.to_hash, body]
    end

  end
end