# encoding: UTF-8
require "docker_helper"

describe "Operating system" do
  subject do
    os
  end
  it "is Alpine Linux 3.6" do
    expect(subject[:family]).to eq("alpine")
    expect(subject[:release]).to match(/^3\.6\./)
  end
end

describe "Commands" do
  [
    "/usr/bin/docker-compose"
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

describe "Packages" do
  [
    "bash",
    "ca-certificates",
    "curl",
    "docker",
    "git",
    "jq",
    "libressl",
    "make",
    "openssh-client",
    "ruby",
    "ruby-io-console",
    "ruby-irb",
    "ruby-rdoc",
    "su-exec",
    "tini",
  ].each do |package|
    context package do
      it "is installed" do
        expect(package(package)).to be_installed
      end
    end
  end
end

describe "Ruby gems" do
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
