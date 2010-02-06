require "test_helper"
require 'fixtures/sinatra/app'

class SinatraAppTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end
  def default_value(name)
    Rack::Less::Base.defaults["#{Rack::Less::Options::RACK_ENV_NS}.#{name}"]
  end

  context "Given a Sinatra app using Rack::Less" do    
    context "with default options," do
      setup do
        app.use Rack::Less
      end
      
      context "when a non-existing stylesheet is requested," do
        setup do
          @response = visit "#{default_value('hosted_at')}/does_not_exist.css"
        end

        should "return '#{Rack::Utils::HTTP_STATUS_CODES[404]}'" do
          assert_equal 404, @response.status, "status is not '#{Rack::Utils::HTTP_STATUS_CODES[404]}'"
        end      
      end

      context "when a less stylesheet needing compilation is requested," do
        setup do
          request_stylesheet "raw.css", "compiled.css"
        end
        should_return_compiled_css
      end
    end
    
    context "with compression and caching" do
      setup do
        app.use Rack::Less, :compress => true, :cache => true
      end
      setup do
        request_stylesheet "raw.css", "compiled.css"
      end
      teardown do
        cached_file = File.join(app.public, default_value('hosted_at'), "raw.css")
        FileUtils.rm(cached_file) if File.exists?(cached_file)
      end

      should_return_compiled_css
      
      should "cache compressed css to a file in the public folder" do
        pub_path = File.join(app.public, default_value('hosted_at'))
        assert File.exists?(pub_path), 'the stylesheet hosted folder does not exist'
        cached_file = File.join(pub_path, @css_name)
        assert File.exists?(cached_file), 'the css was not cached to a file'
        cached_compiled = File.open(cached_file) do |file|
          file.read
        end
        assert_equal @compiled.strip.delete!("\n"), cached_compiled.strip, "the compiled css is incorrect"
      end
    end

=begin
    context "when requesting a stylesheet not needing to be compiled" do
      setup do
        @normal = File.open(File.join(app.root, default_value('source_root'), 'normal_compiled.css')) do |file|
          file.read
        end
        @response = visit "#{default_value('hosted_at')}/normal.css"
      end

      should "return compiled LESS" do
        assert_equal @normal.strip, @response.body.strip
      end
    end

    context "when requesting a non LESS stylesheet" do
      setup do
        @just = File.open(File.join(app.root, default_value('source_root'), 'just.css')) do |file|
          file.read
        end
        @response = visit "#{default_value('hosted_at')}/just.css"
      end

      should "return just the CSS" do
        assert_equal @just.strip, @response.body.strip
      end
    end

    context "when requesting many stylesheets needing to be concatted into one" do
      setup do
        app.use Rack::Less do |option|
          option.concat 'all' => ['one', 'two']
        end
        @all = File.open(File.join(app.root, default_value('source_root'), 'all_compiled.css')) do |file|
          file.read
        end
        @response = visit "#{default_value('hosted_at')}/all.css"
      end

      should "return concatted LESS" do
        assert_equal @all.strip, @response.body.strip
      end
    end      
=end

  end

end