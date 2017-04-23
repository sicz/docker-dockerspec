# encoding: UTF-8
require "dockerspec"

describe "rspec" do
  describe command("rspec --version") do
    its(:stdout) {should match /\d\.\d\.\d/}
  end
end
