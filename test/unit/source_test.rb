require "test/helper"
require 'rack/less/source'

class SourceTest < Test::Unit::TestCase
  context 'Rack::Less::Source' do
    setup do
      @source_folder = file_path('test','fixtures','sinatra','app','stylesheets')
      @cache = file_path('test','fixtures','sinatra','public','stylesheets')
    end

    should "require an existing :folder" do
      assert_raise ArgumentError do
         Rack::Less::Source.new('foo')
      end
      assert_raise ArgumentError do
        Rack::Less::Source.new('foo', :folder => file_path('does','not','exist'))
      end
      assert_nothing_raised do
        Rack::Less::Source.new('foo', :folder => @source_folder)
      end
    end

    should "accept both .less and .css extensions, prefering .less over .css though" do
      assert_equal [:less, :css], Rack::Less::Source::PREFERRED_EXTENSIONS
    end

    context "object" do
      setup do
        @basic = Rack::Less::Source.new('basic', :folder => @source_folder)
        @nested = Rack::Less::Source.new('this/source/is/nested', :folder => @source_folder)
        @compressed = Rack::Less::Source.new('compressed', {
          :folder => @source_folder,
          :compress => true
        })
        @cached = Rack::Less::Source.new('cached', {
          :folder => @source_folder,
          :cache => @cache,
          :compress => false
        })
      end

      should "have accessors for path and cache values" do
        assert_respond_to @basic, :path
        assert_equal 'basic', @basic.path
        assert_respond_to @basic, :cache
        assert_equal 'this/source/is/nested', @nested.path
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

      should "have compiled css" do
        assert_respond_to @basic, :to_css, 'engine does not respond to :to_css'
        assert_respond_to @basic, :css, 'engine does not respond to :css'
      end
    end

    context "with no corresponding source" do
      setup do
        @none = Rack::Less::Source.new('none', :folder => @source_folder)
      end

      should "have an empty file list" do
        assert @none.files.empty?, 'engine file list is not empty'
      end

      should "generate no css" do
        assert @none.to_css.empty?, 'engine generated css when it should not have'
      end
    end

    should_compile_source('normal', "needing to be compiled")
    should_compile_source('nested/file', "that is nested, needing to be compiled")
    should_compile_source('css', "that is a CSS stylesheet")


    context "with whitespace compression" do
      setup do
        @compiled = File.read(File.join(@source_folder, "normal_compiled.css"))
        @compressed_normal = Rack::Less::Source.new('normal', {
          :folder => @source_folder,
          :compress => :whitespace
        })
      end

      should "compress the compiled css" do
        assert_equal @compiled.strip.delete("\n"), @compressed_normal.to_css, "the compiled css is compressed incorrectly"
      end
    end

    context "with yui compression" do
      setup do
        @compiled = File.read(File.join(@source_folder, "normal_compiled.css"))
        @compressed_normal = Rack::Less::Source.new('normal', {
          :folder => @source_folder,
          :compress => :yui
        })
      end

      should "compress the compiled css" do
        comp = YUI::CssCompressor.new(Rack::Less::Source::YUI_OPTS).compress(@compiled.strip)
        assert_equal comp, @compressed_normal.to_css, "the compiled css is compressed incorrectly"
      end
    end

    context "with caching" do
      setup do
        @expected = Rack::Less::Source.new('normal', {
          :folder => @source_folder,
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
        @compiled = File.read(File.join(@source_folder, "all_compiled.css"))
        @combinations_before = Rack::Less.config.combinations
        Rack::Less.config.combinations = {'all' => ['all_one', 'all_two']}
        @all = Rack::Less::Source.new('all', :folder => @source_folder)
      end
      teardown do
        Rack::Less.config.combinations = @combinations_before
      end

      should "combine the compiled css" do
        assert_equal @compiled.strip, @all.to_css.strip, "the compiled css is combined incorrectly"
      end
    end

  end
end
