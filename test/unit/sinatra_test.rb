require "#{File.dirname(__FILE__)}/../test_helper"
require "test_app_helper"
require 'fixtures/sinatra/app'

class SinatraTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end
  def default_value(name)
    Rack::Less::Base.defaults["#{Rack::Less::Options::RACK_ENV_NS}.#{name}"]
  end

  context "A Sinatra app using Rack::Less" do    
    should "fail when no options are set" do
      assert_raise ArgumentError do
        app.use Rack::Less
        visit "/"
      end
    end
    
    should "fail when no :root option is set" do
      assert_raise ArgumentError do
        app.use Rack::Less, :compress => true
        visit "/"
      end
    end
    
    should "fail when :root option does not exist" do
      assert_raise ArgumentError do
        app.use Rack::Less do |base|
          base.set :root, file_path('test','fixtures','wtf')
        end
        visit "/"
      end
    end
    
    should "fail when :source option does not exist" do
      assert_raise ArgumentError do
        app.use Rack::Less do |base|
          base.set :root, file_path('test','fixtures','sinatra')
          base.set :source, 'wtf'
        end
        visit "/"
      end
    end
    
    context "requesting valid LESS" do
      setup do
        app.use Rack::Less do |base|
          base.set :root, file_path('test','fixtures','sinatra')
        end
        @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'normal_compiled.css'))
        @response = visit "/stylesheets/normal.css"
      end

      should_respond_with_compiled_css
    end
  end

end