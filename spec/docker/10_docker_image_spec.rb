require "docker_helper"

### DOCKER_IMAGE ###############################################################

describe "Docker image", :test => :docker_image do
  # Default Serverspec backend
  before(:each) { set :backend, :docker }

  ### DOCKER_IMAGE #############################################################

  describe docker_image(ENV["DOCKER_IMAGE"]) do
    # Execute Serverspec commands locally
    before(:each) { set :backend, :exec }
    it { is_expected.to exist }
  end

  ### OS #######################################################################

  describe "Operating system" do
    context "family" do
      subject { os[:family] }
      it { is_expected.to eq("alpine") }
    end
  end

  ### PACKAGES #################################################################

  describe "Packages" do

    # [package, version, installer]
    packages = [
      "git",
      "make",
      "openssh-client",
      ["ruby",                    ENV["RUBY_VERSION"]],
      ["ruby-io-console",         ENV["RUBY_VERSION"]],
      ["ruby-irb",                ENV["RUBY_VERSION"]],
      ["ruby-rdoc",               ENV["RUBY_VERSION"]],
      ["docker-api",              ENV["GEM_DOCKER_API_VERSION"],  "gem"],
      ["rspec",                   ENV["GEM_RSPEC_VERSION"],       "gem"],
      ["specinfra",               ENV["GEM_SPECINFRA_VERSION"],   "gem"],
      ["serverspec",              ENV["GEM_SERVERSPEC_VERSION"],  "gem"],
    ]

    packages.each do |package, version, installer|
      describe package(package) do
        it { is_expected.to be_installed }                        if installer.nil? && version.nil?
        it { is_expected.to be_installed.with_version(version) }  if installer.nil? && ! version.nil?
        it { is_expected.to be_installed.by(installer) }          if ! installer.nil? && version.nil?
        it { is_expected.to be_installed.by(installer).with_version(version) } if ! installer.nil? && ! version.nil?
      end
    end
  end

  ### COMMANDS #################################################################

  describe "Commands" do

    # [command, version, args]
    commands = [
      ["/usr/bin/docker",         ENV["DOCKER_VERSION"]],
      ["/usr/bin/docker-compose", ENV["DOCKER_COMPOSE_VERSION"]],
    ]

    commands.each do |command, version, args|
      describe "Command \"#{command}\"" do
        subject { file(command) }
        let(:version_regex) { /\W#{version}\W/ }
        let(:version_cmd) { "#{command} #{args.nil? ? "--version" : "#{args}"}" }
        it "should be installed#{version.nil? ? nil : " with version \"#{version}\""}" do
          expect(subject).to exist
          expect(subject).to be_executable
          expect(command(version_cmd).stdout).to match(version_regex) unless version.nil?
        end
      end
    end
  end

  ### FILES ####################################################################

  describe "Files" do

    # [file, mode, user, group, [expectations]]
    files = [
      ["/docker-entrypoint.sh", 755, "root", "root", [:be_file]],
    ]

    files.each do |file, mode, user, group, expectations|
      expectations ||= []
      context file(file) do
        it { is_expected.to exist }
        it { is_expected.to be_file }       if expectations.include?(:be_file)
        it { is_expected.to be_directory }  if expectations.include?(:be_directory)
        it { is_expected.to be_mode(mode) } unless mode.nil?
        it { is_expected.to be_owned_by(user) } unless user.nil?
        it { is_expected.to be_grouped_into(group) } unless group.nil?
        its(:sha256sum) do
          is_expected.to eq(
              Digest::SHA256.file("rootfs/#{subject.name}").to_s
          )
        end if expectations.include?(:eq_sha256sum)
      end
    end
  end

  ##############################################################################

end

################################################################################
