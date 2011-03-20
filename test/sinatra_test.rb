require "test/helper"
require "test/app_helper"
require 'test/fixtures/sinatra/app'

class SinatraTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end
  def default_value(name)
    Rack::Less::Base.defaults["#{Rack::Less::Options::RACK_ENV_NS}.#{name}"]
  end

  context "A Sinatra app using Rack::Less" do

    context "requesting valid LESS" do
      setup do
        app.use Rack::Less,
          :root => file_path('test','fixtures','sinatra')

        @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'normal_compiled.css'))
        @response = visit "/stylesheets/normal.css"
      end

      should_respond_with_compiled_css
    end

    context "requesting a nested valid LESS" do
      setup do
        app.use Rack::Less,
          :root => file_path('test','fixtures','sinatra')

        @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'nested', 'file_compiled.css'))
        @response = visit "/stylesheets/nested/file.css"
      end

      should_respond_with_compiled_css
    end

  end

end