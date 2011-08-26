require "assert"
require "test/app_helper"
require 'test/fixtures/sinatra/app'

module Rack::Less

  class SinatraTests < Assert::Context
    desc "rack less hosted by a sinatra app"
    setup do
      Rack::Less.configure do |config|
        config.compress = false
        config.cache = false
      end
      app.use Rack::Less,
        :root => file_path('test','fixtures','sinatra')
    end

    def app
      @app ||= SinatraApp
    end

  end

  class SinatraValidCss < SinatraTests
    desc "requesting valid LESS"
    setup do
      @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'normal_compiled.css'))
      @response = visit "/stylesheets/normal.css"
    end

    should_respond_with_compiled_css
  end

  class SinatraNestedValidCss < SinatraTests
    desc "requesting a nested valid LESS"
    setup do
      @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'nested', 'file_compiled.css'))
      @response = visit "/stylesheets/nested/file.css"
    end

    should_respond_with_compiled_css
  end

  class SinatraReallyNestedValidCss < SinatraTests
    desc "requesting a really nested valid LESS"
    setup do
      @compiled = File.read(file_path('test','fixtures','sinatra','app','stylesheets', 'nested', 'really', 'really_compiled.css'))
      @response = visit "/stylesheets/nested/really/really.css"
    end

    should_respond_with_compiled_css
  end


end
