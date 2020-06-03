title 'Tests to confirm make works as expected'

plan_name = input('plan_name', value: 'make')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
make_path = command("hab pkg path #{plan_ident}")
make_pkg_ident = ((make_path.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]

control 'core-plans-make-works-001' do
  impact 1.0
  title 'should be installed'
  desc '
  '
  describe make_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
end

control 'core-plans-make-works-002' do
  impact 1.0
  title 'should be at correct version'
  desc '
  '
  describe command("DEBUG=true; hab pkg exec #{make_pkg_ident} make --version") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /GNU Make 4.2.1/ }
    its('stderr') { should be_empty }
  end
end

control 'core-plans-make-works-003' do
  impact 1.0
  title 'should act on a Makefile'
  desc '
  '
  describe command("DEBUG=true; hab pkg exec #{make_pkg_ident} make --directory /hab/svc/make/config/fixtures/ ci-test") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Make in CI/ }
    its('stderr') { should be_empty }
  end
end
