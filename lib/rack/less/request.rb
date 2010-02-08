require 'rack/request'
require 'rack/less'
require 'rack/less/options'
require 'rack/less/source'

module Rack::Less

  # Provides access to the HTTP request.
  # Request objects respond to everything defined by Rack::Request
  # as well as some additional convenience methods defined here
  # => from: http://github.com/rtomayko/rack-cache/blob/master/lib/rack/cache/request.rb

  class Request < Rack::Request
    include Rack::Less::Options
    
    CSS_PATH_REGEX = /\A.*\/(\w+)\.(\w+)\Z/
    CSS_PATH_FORMATS = ['css']

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
    
    def http_accept
      @env['HTTP_ACCEPT']
    end
    
    def path_resource_name
      path_info =~ CSS_PATH_REGEX ? path_info.match(CSS_PATH_REGEX)[1] : nil
    end
    
    def path_resource_format
      path_info =~ CSS_PATH_REGEX ? path_info.match(CSS_PATH_REGEX)[2] : nil
    end

    # The Rack::Less::Source that the request is for
    def source
      @source ||= begin
        cache = if options(:cache)
          File.join(options(:root), options(:public), options(:hosted_at))
        else
          nil
        end
        source_opts = {
          :folder   => File.join(options(:root), options(:source)),
          :cache    => cache,
          :compress => options(:compress)
        }
        Source.new(path_resource_name, source_opts)
      end
    end

    def for_css?
      p "ha: #{http_accept.inspect}"
      p "mt: #{media_type.inspect}"
      (http_accept && http_accept.include?(Rack::Less::MIME_TYPE)) ||
      (media_type  && media_type.include?(Rack::Less::MIME_TYPE )) ||
      CSS_PATH_FORMATS.include?(path_resource_format)
    end

    # Determine if the request is for existing LESS CSS file
    # This will be called on every request so speed is an issue
    # => first check if the request is a GET on a css resource (fast)
    # => then check for less source files that match the request (slow)
    def for_less?
      get? && for_css? && !source.files.empty?
    end
    
  end
end
