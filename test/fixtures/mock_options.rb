class MockOptions
  include Rack::Less::Options
  
  def initialize
    @env = nil
    initialize_options
  end
end

