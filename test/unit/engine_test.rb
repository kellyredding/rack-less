require 'test_helper'
require 'rack/less/options'
require 'rack/less/engine'
require 'fixtures/mock_options'

class EngineTest < Test::Unit::TestCase
  context 'Rack::Less::Engine' do
    setup do 
      @source_path = file_path('test','fixtures','sinatra','app','stylesheets')
      @cache = file_path('test','fixtures','sinatra','public','stylesheets')
    end

    should "require an existing :source_path" do
      assert_raise ArgumentError do
         Rack::Less::Engine.new('foo')
      end
      assert_raise ArgumentError do
        Rack::Less::Engine.new('foo', :source_path => file_path('does','not','exist'))
      end
      assert_nothing_raised do
        Rack::Less::Engine.new('foo', :source_path => @source_path)
      end
    end
    
    should "accept both .less and .css extensions, prefering .less over .css though" do
      assert_equal [:less, :css], Rack::Less::Engine::PREFERRED_EXTENSIONS
    end
    
    context "object" do
      setup do
        @basic = Rack::Less::Engine.new('basic', :source_path => @source_path)
        @compressed = Rack::Less::Engine.new('compressed', {
          :source_path => @source_path,
          :compress => true
        })
        @cached = Rack::Less::Engine.new('cached', {
          :source_path => @source_path,
          :cache => @cache,
          :compress => false
        })
      end
      
      should "know it's name" do 
        assert_respond_to @basic, :css_name
        assert_equal 'basic', @basic.css_name
      end
      
      should "have an option for using compression" do
        assert_equal false, @basic.compress?, 'the basic app should not compress'
        assert_equal true, @compressed.compress?, 'the compressed app should compress'
        assert_equal false, @cached.compress?, 'the cached app should not compress'
      end
      
      should "have an option for caching output to files" do
        assert_equal false, @basic.cache?, 'the basic app should not cache'
        assert_equal true, @cached.cache?, 'the cached app should cache'
      end

      should "have a source files list" do
        assert_respond_to @basic, :files, 'engine does not respond to :files'
        assert_kind_of Array, @basic.files, 'the engine files is not an Array'
      end

      should "be have compiled css" do
        assert_respond_to @basic, :to_css, 'engine does not respond to :to_css'
        assert_respond_to @basic, :css, 'engine does not respond to :css'
      end
    end
    
    context "with no corresponding source" do
      setup do
        @none = Rack::Less::Engine.new('none', :source_path => @source_path)
      end

      should "have an empty file list" do
        assert @none.files.empty?, 'engine file list is not empty'
      end

      should "generate no css" do
        assert @none.to_css.empty?, 'engine generated css when it should not have'
      end
    end

    should_compile_source('normal', "needing to be compiled")
    should_compile_source('css', "that is a CSS stylesheet")


    context "with compression" do
      setup do
        @compiled = File.read(File.join(@source_path, "normal_compiled.css"))
        @compressed_normal = Rack::Less::Engine.new('normal', {
          :source_path => @source_path,
          :compress => true
        })
      end

      should "compress the compiled css" do
        assert_equal @compiled.strip.delete!("\n"), @compressed_normal.to_css, "the compiled css is compressed incorrectly"
      end
    end

    context "with caching" do
      setup do
        @expected = Rack::Less::Engine.new('normal', {
          :source_path => @source_path,
          :cache => @cache
        }).to_css
        @cached_file = File.join(@cache, "normal.css")
      end
      teardown do
        FileUtils.rm(@cached_file) if File.exists?(@cached_file)
      end

      should "store the compiled css to a file in the cache" do
        assert File.exists?(@cache), 'the cache folder does not exist'
        assert File.exists?(@cached_file), 'the css was not cached to a file'
        assert_equal @expected.strip, File.read(@cached_file).strip, "the compiled css is incorrect"
      end
    end

    context "that is a combination of multiple files" do
      setup do
        @compiled = File.read(File.join(@source_path, "all_compiled.css"))
        @all = Rack::Less::Engine.new('all', {
          :source_path => @source_path,
          :concat => {'all' => ['all_one', 'all_two']}
        })
      end

      should "combine the compiled css" do
        assert_equal @compiled.strip, @all.to_css.strip, "the compiled css is combined incorrectly"
      end
    end

  end
end
