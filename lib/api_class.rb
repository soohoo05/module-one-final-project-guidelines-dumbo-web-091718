require 'GuideboxWrapper'

class ApiCall
  attr_reader :movie_guide, :tv_guide
  def initialize
    @movie_guide = GuideboxWrapper::GuideboxMovie.new("f07b83af6532c345abdd64e6c92fcd368ad34488", "US")
    @tv_guide = GuideboxWrapper::GuideboxTv.new("f07b83af6532c345abdd64e6c92fcd368ad34488", "US")
  end
end
