require "#{File.dirname(__FILE__)}/../test_helper"
require 'rack/less/response'

class RequestTest < Test::Unit::TestCase

  context 'Rack::Less::Response' do
    setup do
      @defaults = env_defaults
      @css = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'css_compiled.css'))
      @response = less_response(@css)
    end

    should "have some attributes" do
      [ :options,
        :status,
        :headers,
        :body,
        :content_length,
        :content_type,
        :to_rack
      ].each do |a|
        assert_respond_to @response, a, "request does not respond to #{a.inspect}"
      end   
    end
    
    should "set it's status to '#{Rack::Utils::HTTP_STATUS_CODES[200]}'" do 
      assert_equal 200, @response.status
    end

    should "set it's Content-Type to '#{Rack::Less::MEDIA_TYPE}'" do 
      assert_equal Rack::Less::MEDIA_TYPE, @response.content_type, 'the content_type accessor is incorrect'
      assert_equal Rack::Less::MEDIA_TYPE, @response.headers['Content-Type'], 'the Content-Type header is incorrect'
    end

    should "set it's Content-Length appropriately" do
      assert_equal Rack::Less::Response.content_length(@css), @response.content_length, 'the content_length accessor is incorrect'
      assert_equal Rack::Less::Response.content_length(@css), @response.headers['Content-Length'].to_i
    end
  end

end
