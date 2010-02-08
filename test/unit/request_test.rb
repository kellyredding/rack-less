require "#{File.dirname(__FILE__)}/../test_helper"
require 'rack/less/request'

class RequestTest < Test::Unit::TestCase

  context 'Rack::Less::Request' do
    setup do 
      @defaults = Rack::Less::Base.defaults.merge({
        Rack::Less::Base.option_name(:root) => file_path('test','fixtures','sinatra')
      })
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
        assert_equal 'css', less_request("GET", "/foo.css").path_resource_format
        assert_equal 'css', less_request("GET", "/foo/bar.css").path_resource_format
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
      :resource    => "/foo.html",
      :description => "a non-css resource"
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

  end

end
