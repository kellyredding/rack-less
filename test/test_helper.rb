require 'rubygems'
require 'test/unit'
require 'shoulda'

# Add test and lib paths to the $LOAD_PATH
[ File.dirname(__FILE__),
  File.join(File.dirname(__FILE__), '..', 'lib')
].each do |path|
  full_path = File.expand_path(path)
  $LOAD_PATH.unshift(full_path) unless $LOAD_PATH.include?(full_path)
end

require 'rack/less'

class Test::Unit::TestCase
  
  def file_path(*segments)
    segs = segments.unshift([File.dirname(__FILE__), '..']).flatten
    File.expand_path(segs.join(File::SEPARATOR))
  end
  
  def self.should_compile_source(name, desc)
    context desc do
      setup do
        @compiled = File.read(File.join(@source_folder, "#{name}_compiled.css"))
        @source = Rack::Less::Source.new(name, :folder => @source_folder)
      end
      
      should "compile LESS" do
        assert_equal @compiled.strip, @source.compiled.strip, '.compiled is incorrect'
        assert_equal @compiled.strip, @source.to_css.strip, '.to_css is incorrect'
        assert_equal @compiled.strip, @source.css.strip, '.css is incorrect'
      end
    end
  end
  
end