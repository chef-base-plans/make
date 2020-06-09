title 'Tests to confirm make works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'make')

control 'core-plans-make-works' do
  impact 1.0
  title 'Ensure make works as expected'
  desc '
  Verify make by ensuring (1) its installation directory exists; (2) that
  it returns the expected version; (3) it runs successfully against a sample Makefile
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]
  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} make --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /GNU Make #{plan_pkg_version}/ }
    its('stderr') { should be_empty }
  end

  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} make --directory /hab/svc/make/config/fixtures/ ci-test") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Make in CI/ }
    its('stderr') { should be_empty }
  end
end