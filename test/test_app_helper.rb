require 'rack/test'
require 'webrat'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
 
  Webrat.configure do |config|
    config.mode = :rack
  end 

  def request_stylesheet(less_name, compiled_name)
    @css_name = less_name
    @compiled = File.open(File.join(app.root, default_value('source_root'), compiled_name)) do |file|
      file.read
    end
    @response = visit "#{default_value('hosted_at')}/#{@css_name}"
  end
  
  class << self

    def should_return_compiled_css
      should "return compiled css" do
        assert_equal 200, @response.status, "status is not '#{Rack::Utils::HTTP_STATUS_CODES[200]}'"
        assert_equal Rack::Less::MEDIA_TYPE, @response.headers["Content-Type"], "content type is not '#{Rack::Less::MEDIA_TYPE}'"
        assert_equal @compiled.strip, @response.body.strip, "the compiled css is incorrect"
      end
    end

  end

end
