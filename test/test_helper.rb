require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'webrat'

# Add test and lib paths to the $LOAD_PATH
[ File.dirname(__FILE__),
  File.join(File.dirname(__FILE__), '..', 'lib')
].each do |path|
  full_path = File.expand_path(path)
  $LOAD_PATH.unshift(full_path) unless $LOAD_PATH.include?(full_path)
end

require 'rack/less'

class Test::Unit::TestCase
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
 
  Webrat.configure do |config|
    config.mode = :rack
  end
 
end
