require "assert"
require 'rack/less/config'

module Rack::Less

  class ConfigTests < Assert::Context
    desc 'the rack-less config'
    setup { @config = Config.new }
    subject { @config }

    should have_accessors :cache, :compress, :combinations, :cache_bust
    should have_readers :cache?, :compress?

    { :cache => false,
      :compress => false,
      :combinations => {},
      :cache_bust => nil
    }.each do |k,v|
      should "default #{k} correctly" do
        assert_equal v, @config.send(k)
      end
    end

    should "provide boolean readers" do
      assert_equal !!@config.cache, @config.cache?
      assert_equal !!@config.compress, @config.compress?
    end

    should "allow init with setting hash" do
      settings = {
        :cache => true,
        :compress => true,
        :combinations => {
          'all' => ['one', 'two']
        },
        :cache_bust => false
      }
      config = Rack::Less::Config.new settings

      assert_equal true, config.cache
      assert_equal true, config.compress
      combinations = {'all' => ['one', 'two']}
      assert_equal combinations, config.combinations
    end

    should "be accessible at Rack::Less class level" do
      assert_respond_to :configure, Rack::Less
      assert_respond_to :config, Rack::Less
      assert_respond_to :config=, Rack::Less
      assert_respond_to :combinations, Rack::Less
      assert_respond_to :cache_bust, Rack::Less
      assert_respond_to :stylesheet, Rack::Less
    end

  end

  class NewConfigTests < Assert::Context
    desc "a new configuration"
    setup do
      @old_config = Rack::Less.config
      @settings = {
        :cache => true,
        :compress => true,
        :combinations => { 'all' => ['one', 'two'] },
        :cache_bust => false
      }
      @traditional_config = Config.new @settings
    end
    teardown do
      Rack::Less.config = @old_config
    end

    should "allow Rack::Less to directly apply settings" do
      Rack::Less.config = @traditional_config.dup

      assert_equal @traditional_config.cache, Rack::Less.config.cache
      assert_equal @traditional_config.compress, Rack::Less.config.compress
      assert_equal @traditional_config.combinations, Rack::Less.config.combinations
      assert_equal @traditional_config.cache_bust, Rack::Less.config.cache_bust
    end

    should "allow Rack::Less to apply settings using a block" do
      Rack::Less.configure do |config|
        config.cache    = true
        config.compress = true
        config.combinations = { 'all' => ['one', 'two'] }
        config.cache_bust = false
      end

      assert_equal @traditional_config.cache, Rack::Less.config.cache
      assert_equal @traditional_config.compress, Rack::Less.config.compress
      assert_equal @traditional_config.combinations, Rack::Less.config.combinations
      assert_equal @traditional_config.cache_bust, Rack::Less.config.cache_bust
    end

  end

  class ConfigCombinationStylesheetTests < ConfigTests
    desc "a rack less config"
    setup do
      @settings = {
        :combinations => { 'all' => ['one', 'two'] },
        :cache_bust => false
      }
      @config = Rack::Less::Config.new @settings
    end

    should "access #combinations by name" do
      assert_equal [], @config.combinations('one')
      assert_equal [], @config.combinations('wtf')
      assert_equal ['one.css', 'two.css'], @config.combinations('all')
    end

    should "generate #stylesheet references by name" do
      assert_equal 'one.css', @config.stylesheet('one')
      assert_equal 'wtf.css', @config.stylesheet('wtf')
      assert_equal ['one.css', 'two.css'], @config.stylesheet('all')
    end

  end

  class CachedConfigComboStylesheetTests < ConfigCombinationStylesheetTests
    desc "when cache setting is true"
    setup do
      @settings[:cache] = true
      @config = Rack::Less::Config.new @settings
    end

    should "use the lookup combos and stylesheets by the cache name" do
      assert_equal 'all.css', @config.combinations('all')

      assert_equal 'one.css', @config.stylesheet('one')
      assert_equal 'all.css', @config.stylesheet('all')
    end

  end

  class ConfigCacheBustTests < ConfigCombinationStylesheetTests

    should "should not put in a cache bust value when cache_bust is false" do
      @settings[:cache_bust] = false
      config = Rack::Less::Config.new @settings

      assert_equal 'one.css', config.stylesheet('one')
    end

    should "should not put in a cache bust value when cache_bust is nil" do
      @settings[:cache_bust] = nil
      config = Rack::Less::Config.new @settings

      assert_equal 'one.css', config.stylesheet('one')
    end

    should "always put a timestamp value on the end of the href when cache_bust is true" do
      @settings[:cache_bust] = true
      config = Rack::Less::Config.new @settings

      assert_match /one.css\?[0-9]+/, config.stylesheet('one')
    end

  end

  class ConfigTimeStampTests < ConfigCombinationStylesheetTests
    desc "when timestamp specified"
    setup do
      @stamp = Time.now.to_i - 100_000
      @settings[:cache_bust] = @stamp
      @config = Rack::Less::Config.new @settings
    end

    should "always use that timestamp" do
      assert_equal ["one.css?#{@stamp}", "two.css?#{@stamp}"], @config.stylesheet('all')
    end

  end

end
