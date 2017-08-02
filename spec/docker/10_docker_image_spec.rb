# encoding: UTF-8
require "docker_helper"

describe "Package" do
  [
    "git",
    "make",
    "openssh-client",
    "ruby",
    "ruby-io-console",
    "ruby-irb",
    "ruby-rdoc",
  ].each do |package|
    context package do
      it "is installed" do
        expect(package(package)).to be_installed
      end
    end
  end
end

describe "Command" do
  [
    "/usr/bin/docker",
    "/usr/bin/docker-compose",
    "/usr/bin/rspec"
  ].each do |command|
    context command do
      it "is installed" do
        expect(file(command)).to exist
        expect(file(command)).to be_file
        expect(file(command)).to be_executable
      end
    end
  end
end

describe "Ruby gem" do
  [
    "docker-api",
    "rspec",
    "serverspec",
  ].each do |package|
    context package do
      it "is installed" do
        expect(package(package)).to be_installed.by('gem')
      end
    end
  end
end
