# encoding: UTF-8
require "docker_helper"

describe "Operating system" do
  subject do
    os
  end
  it "is Alpine Linux 3.5" do
    expect(subject[:family]).to eq("alpine")
    expect(subject[:release]).to match(/^3\.5\./)
  end
end

describe "Package" do
  [
    "bash",
    "ca-certificates",
    "curl",
    "git",
    "jq",
    "libressl",
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

describe "Docker entrypoint file" do
  context "/docker-entrypoint.sh" do
    it "has set permissions" do
      expect(file("/docker-entrypoint.sh")).to exist
      expect(file("/docker-entrypoint.sh")).to be_executable
    end
  end
  [
    "/docker-entrypoint.d/10-default-command.sh",
  ].each do |file|
    context file do
      it "exists" do
        expect(file(file)).to exist
        expect(file(file)).to be_readable
      end
    end
  end
end
