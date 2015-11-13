module Helpers

  # figure this out. how to do fixtures
  def fixture_path
    File.expand_path('fixtures', 'spec')
  end

  def fixture(file)
    f = File.read(fixture_path + '/' + file)
    f
  end

end
