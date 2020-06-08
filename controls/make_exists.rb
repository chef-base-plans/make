title 'Tests to confirm make exists'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'make')
plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
command_relative_path = input('command_relative_path', value: '/bin/make')
command_full_path = plan_installation_directory.stdout.strip + "#{command_relative_path}"

control 'core-plans-make-exists' do
  impact 1.0
  title 'Ensure make exists'
  desc '
  Verify make by ensuring /bin/make exists'
  
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  describe file(command_full_path) do
    it { should exist }
  end
end
