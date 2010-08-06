require "test_helper"
require 'rack/less/request'

class RequestTest < Test::Unit::TestCase

  context 'Rack::Less::Request' do
    setup do 
      @defaults = env_defaults
    end
    
    context "basic object" do
      should "have some attributes" do
        [ :options,
          :request_method,
          :path_info,
          :path_resource_name,
          :path_resource_format,
          :source,
          :for_css?,
          :for_less?
        ].each do |a|
          assert_respond_to less_request("GET", "/foo.css"), a, "request does not respond to #{a.inspect}"
        end   
      end
      
      should "know it's resource name" do
        assert_equal 'foo', less_request("GET", "/foo.css").path_resource_name
        assert_equal 'bar', less_request("GET", "/foo/bar.css").path_resource_name
      end
      
      should "know it's resource format" do
        assert_equal '.css', less_request("GET", "/foo.css").path_resource_format
        assert_equal '.css', less_request("GET", "/foo/bar.css").path_resource_format
      end
    end
    
    context "#source " do
      should "match :compress settings with Rack::Less:Config" do
        req = less_request("GET", "/stylesheets/normal.css")
        assert_equal Rack::Less.config.compress?, req.source.compress?
      end
      
      should "set it's cache value to nil when Rack::Less not configured to cache" do
        Rack::Less.config = Rack::Less::Config.new
        req = less_request("GET", "/stylesheets/normal.css")

        assert_equal false, req.source.cache?
        assert_equal nil, req.source.cache
      end

      should "set it's cache to the appropriate path when Rack::Less configured to cache" do
        Rack::Less.config = Rack::Less::Config.new :cache => true
        req = less_request("GET", "/stylesheets/normal.css")
        cache_path = File.join(req.options(:root), req.options(:public), req.options(:hosted_at))
        
        assert_equal true, req.source.cache?
        assert_equal cache_path, req.source.cache
      end
    end
    
    should_not_be_a_valid_rack_less_request({
      :method      => "POST",
      :resource    => "/foo.html",
      :description => "a non-css resource"
    })

    should_not_be_a_valid_rack_less_request({
      :method      => "POST",
      :resource    => "/foo.css",
      :description => "a css resource"
    })
    
    should_not_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/foo.css",
      :description => "a css resource hosted somewhere other than where Rack::Less expects them"
    })

    should_not_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/stylesheets/foo.css",
      :description => "a css resource hosted where Rack::Less expects them but does not match any source"
    })

    should_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/stylesheets/normal.css",
      :description => "a css resource hosted where Rack::Less expects them that matches source"
    })

    should_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/stylesheets/some-styles.css",
      :description => "a proper css resource with a '-' in the name"
    })

    should_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/stylesheets/some_styles.css",
      :description => "a proper css resource with a '_' in the name"
    })

    should_be_a_valid_rack_less_request({
      :method      => "GET",
      :resource    => "/stylesheets/styles1.css",
      :description => "a proper css resource with a number in the name"
    })
  end

end
