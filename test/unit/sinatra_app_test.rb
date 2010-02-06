require "test_helper"
require 'fixtures/sinatra/app'

class SinatraAppTest < Test::Unit::TestCase

  def app
    @app ||= SinatraApp
  end

  context "Given a Sinatra app using Rack::Less" do
    
    context "with default options," do
      setup do
        @default = Rack::Less::Options::DEFAULT
        app.use Rack::Less
      end
      
      context "when a non-existing stylesheet is requested, it" do
        setup do
          @response = visit "#{@default[:hosted_root]}/does_not_exist.css"
        end

        should "return '#{Rack::Utils::HTTP_STATUS_CODES[404]}'" do
          assert_equal 404, @response.status, "status is not '#{Rack::Utils::HTTP_STATUS_CODES[404]}'"
        end      
      end

    end

=begin
    context "when requesting a stylesheet needing to be compiled" do
      setup do
        @css_name = "raw.css"
        @compiled = File.open(File.join(app.root, @default[:source_root], "compiled.css")) do |file|
          file.read
        end
        @response = visit "#{@default[:hosted_root]}/#{@css_name}"
      end

      should "return compiled LESS" do
        assert_equal 200, @response.status
        assert_equal Rack::Less::CONTENT_TYPE, @response.headers["Content-Type"]
        assert_equal @compiled.strip, @response.body.strip
      end

      context "in production with compression" do
        setup do
          app.use Rack::Less :compress => true
          @response = visit "#{@default[:hosted_root]}/#{@css_name}"
        end

        should "page cache the compiled css to a public file" do
          pub_path = File.join(app.public, @default[:hosted_root])
          assert File.exists?(pub_path)
          cached_file = File.join(pub_path, @css_name)
          assert File.exists?(cached_file)
          cached_compiled = File.open(cached_file) do |file|
            file.read
          end
          assert_equal @compiled.strip.delete!("\n"), cached_compiled.strip
        end
      end

    end

    context "when requesting a stylesheet not needing to be compiled" do
      setup do
        @normal = File.open(File.join(app.root, @default[:source_root], 'normal_compiled.css')) do |file|
          file.read
        end
        @response = visit "#{@default[:hosted_root]}/normal.css"
      end

      should "return compiled LESS" do
        assert_equal @normal.strip, @response.body.strip
      end
    end

    context "when requesting a non LESS stylesheet" do
      setup do
        @just = File.open(File.join(app.root, @default[:source_root], 'just.css')) do |file|
          file.read
        end
        @response = visit "#{@default[:hosted_root]}/just.css"
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
        @all = File.open(File.join(app.root, @default[:source_root], 'all_compiled.css')) do |file|
          file.read
        end
        @response = visit "#{@default[:hosted_root]}/all.css"
      end

      should "return concatted LESS" do
        assert_equal @all.strip, @response.body.strip
      end
    end      
=end

  end

end