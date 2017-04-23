# encoding: UTF-8
require "docker_helper"

describe "rspec" do
  describe command("rspec --version") do
    its(:stdout) {should match /\d\.\d\.\d/}
  end
end
