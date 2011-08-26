require "assert"
require 'rack/less/source'

require 'differ'

module Rack::Less

  class BootstrapSourceTests < Assert::Context
    desc 'the bootstrap less source'
    setup do
      @source_folder = file_path('test','fixtures', 'bootstrap_v1.1.0')
      @compiled = File.read(File.join(@source_folder, "bootstrap-1.1.0.css"))
      @source = Source.new('bootstrap', :folder => @source_folder)
    end

    should "compile correctly" do
      assert_equal @compiled.strip, @source.compiled.strip, '.compiled is incorrect'
      assert_equal @compiled.strip, @source.to_css.strip, '.to_css is incorrect'
      assert_equal @compiled.strip, @source.css.strip, '.css is incorrect'

      puts Differ.diff_by_line(@source.compiled.strip, @compiled.strip).format_as(:color)
    end

  end

end
