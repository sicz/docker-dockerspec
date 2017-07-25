# encoding: UTF-8
require "docker_helper"

# Keep in sync with:
# - https://github.com/sicz/docker-baseimage-alpine
# - https://github.com/sicz/docker-baseimage-centos
# - https://github.com/sicz/docker-dockerspec
describe "Operating system" do
  subject do
    os
  end
  it "is Alpine Linux #{ENV["DOCKER_TAG"]}" do
    expect(subject[:family]).to eq("alpine")
    expect(subject[:release]).to match(/^#{Regexp.escape(ENV["DOCKER_TAG"])}\./)
  end
end

describe "Package" do
  [
    "bash",
    "ca-certificates",
    "curl",
    "jq",
    "libressl",
    "runit",
    "su-exec",
    "tini",
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
    it "is installed" do
      expect(file("/docker-entrypoint.sh")).to exist
      expect(file("/docker-entrypoint.sh")).to be_file
      expect(file("/docker-entrypoint.sh")).to be_executable
    end
  end
  [
    "/docker-entrypoint.d/01-lib-messages.sh",
    "/docker-entrypoint.d/02-lib-wait-for.sh",
    "/docker-entrypoint.d/10-default-command.sh",
    "/docker-entrypoint.d/20-docker-introspection.sh",
    "/docker-entrypoint.d/30-environment-certs.sh",
    "/docker-entrypoint.d/40-server-certs.sh",
    "/docker-entrypoint.d/90-exec-command.sh",
  ].each do |file|
    context file do
      it "is installed" do
        expect(file(file)).to exist
        expect(file(file)).to be_file
        expect(file(file)).to be_readable
      end
    end
  end
end

describe "Configuration file" do
  [
    "/etc/ssl/openssl.cnf",
  ].each do |file|
    context file do
      it "is installed" do
        expect(file(file)).to exist
        expect(file(file)).to be_file
        expect(file(file)).to be_readable
      end
    end
  end
end
