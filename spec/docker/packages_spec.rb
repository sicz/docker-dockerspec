# encoding: UTF-8
require "docker_helper"

describe "packages" do
  [
    "git",
    "make",
    "ruby",
    "ruby-io-console",
    "ruby-irb",
    "ruby-rdoc",
    "openssh-client"
  ].each do |package|
    describe package(package) do
      it { should be_installed }
    end
  end
end
