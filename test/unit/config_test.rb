require "#{File.dirname(__FILE__)}/../test_helper"
require 'rack/less/config'

class ConfigTest < Test::Unit::TestCase
  context 'Rack::Less::Config' do
    setup do
      @config = Rack::Less::Config.new
    end
    
    { :cache => false,
      :compress => false,
      :combinations => {}
    }.each do |k,v|
      should "default #{k} correctly" do
        assert_equal v, @config.send(k)
      end
      
      should "have an accessor for #{k}" do
        assert_respond_to @config, k, "no reader for #{k}"
        assert_respond_to @config, "#{k}=".to_sym, "no writer for #{k}"
      end
    end
    
    should "provide boolean readers" do
      assert_respond_to @config, :cache?, "no reader for :cache?"
      assert_equal (@config.cache == true), @config.cache?
      assert_respond_to @config, :compress?, "no reader for :compress?"
      assert_equal (@config.compress == true), @config.compress?
    end
    
    should "allow init with setting hash" do
      settings = {
        :cache => true,
        :compress => true,
        :combinations => {
          'all' => ['one', 'two']
        }
      }
      config = Rack::Less::Config.new settings
      
      assert_equal true, config.cache
      assert_equal true, config.compress
      combinations = {'all' => ['one', 'two']}
      assert_equal combinations, config.combinations
    end
    
    should "be accessible at Rack::Less class level" do
      assert_respond_to Rack::Less, :configure
      assert_respond_to Rack::Less, :config
      assert_respond_to Rack::Less, :config=
    end
    
    context "given a new configuration" do
      setup do
        @old_config = Rack::Less.config
        @settings = {
          :cache => true,
          :compress => true,
          :combinations => {
            'all' => ['one', 'two']
          }
        }
        @traditional_config = Rack::Less::Config.new @settings
      end
      teardown do
        Rack::Less.config = @old_config
      end
      
      should "allow Rack::Less to directly apply settings" do
        Rack::Less.config = @traditional_config
        assert_equal @traditional_config, Rack::Less.config
      end

      should "allow Rack::Less to apply settings using a block" do
        Rack::Less.configure do |config|
          config.cache    = true
          config.compress = true
          config.combinations = {
            'all' => ['one', 'two']
          }
        end
        assert_equal @traditional_config.cache, Rack::Less.config.cache
        assert_equal @traditional_config.compress, Rack::Less.config.compress
        assert_equal @traditional_config.combinations, Rack::Less.config.combinations
      end
    end

  end
end
