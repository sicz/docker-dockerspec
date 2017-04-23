# encoding: UTF-8
require "docker_helper"

describe "Docker Entrypoint" do
  describe file('/docker-entrypoint.sh') do
    it { should be_executable }
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
    describe file(file) do
      it { should be_file }
    end
  end
end
