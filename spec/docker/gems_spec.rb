# encoding: UTF-8
require "dockerspec"

describe "gems" do
  [
    "docker-api",
    "rspec",
    "serverspec"
  ].each do |package|
    describe package(package) do
      it { should be_installed.by('gem') }
    end
  end
end
