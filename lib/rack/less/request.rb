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

    CSS_PATH_FORMATS = ['.css']

    # The HTTP request method. This is the standard implementation of this
    # method but is respecified here due to libraries that attempt to modify
    # the behavior to respect POST tunnel method specifiers. We always want
    # the real request method.
    def request_method
      @env['REQUEST_METHOD']
    end

    def http_accept
      @env['HTTP_ACCEPT']
    end

    def path_info
      @env['PATH_INFO']
    end

    def hosted_at_option
      # sanitized :hosted_at option
      #  remove any trailing '/'
      #  ensure single leading '/'
      @hosted_at_option ||= options(:hosted_at).sub(/\/+$/, '').sub(/^\/*/, '/')
    end

    def path_info_resource
      # sanitized path to the resource being requested
      #  ensure single leading '/'
      #  remove any resource format
      #  ex:
      #  '/something.css' => '/something'
      #  '/nested/something.css' => '/nested/something'
      #  '///something.css' => '/something'
      #  '/nested///something.css' => '/nested/something'
      @path_info_resource ||= File.join(
        File.dirname(path_info.gsub(/\/+/, '/')).sub(/^#{hosted_at_option}/, ''),
        File.basename(path_info.gsub(/\/+/, '/'), path_info_format)
      ).sub(/^\/*/, '/')
    end

    def path_info_format
      @path_info_format ||= File.extname(path_info.gsub(/\/+/, '/'))
    end

    def cache
      File.join(options(:root), options(:public), hosted_at_option)
    end

    # The Rack::Less::Source that the request is for
    def source
      @source ||= begin
        source_opts = {
          :folder   => File.join(options(:root), options(:source)),
          :cache    => Rack::Less.config.cache? ? cache : nil,
          :update_cache => Rack::Less.config.update_cache,
          :compress => Rack::Less.config.compress?
        }
        Source.new(path_info_resource, source_opts)
      end
    end

    def for_css?
      (http_accept && http_accept.include?(Rack::Less::MIME_TYPE)) ||
      (media_type  && media_type.include?(Rack::Less::MIME_TYPE )) ||
      CSS_PATH_FORMATS.include?(path_info_format)
    end

    def hosted_at?
      path_info =~ /^#{hosted_at_option}\//
    end

    def cached?
      !source.update_cache? && File.exists?(File.join(cache, "#{path_info_resource}#{path_info_format}"))
    end

    # Determine if the request is for a non-cached existing LESS CSS source file
    # This will be called on every request so speed is an issue
    # => first check if the request is a GET on a css resource in :hosted_at (fast)
    # => don't process if a file has already been cached
    # => otherwise, check for less source files that match the request (slow)
    def for_less?
      get? &&               # GET on css resource in :hosted_at (fast, check first)
      for_css? &&
      hosted_at? &&
      !cached? &&           # resource not cached (little slower)
      !source.files.empty?  # there is source for the resource (slow, check last)
    end

  end
end
