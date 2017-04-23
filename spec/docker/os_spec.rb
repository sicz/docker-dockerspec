# encoding: UTF-8
require "dockerspec"

describe "os" do
  describe os[:release] do
    it { should match /3\.5\.\d/ }
  end
end
