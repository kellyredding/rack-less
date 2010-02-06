require "test_helper"
require 'fixtures/sinatra/app'

class SinatraAppTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end

  context "using Rack::Less with Sinatra" do

    setup do
      app.set :environment, :development
    end

    context "in testing" do
      setup do
        app.set :environment, :test
        visit '/test'
      end
      
      should "should work" do
        assert_contain("this is a test")
      end
    end

  end

end