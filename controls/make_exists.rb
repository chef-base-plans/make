title 'Tests to confirm make exists'

plan_name = input('plan_name', value: 'make')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
make_relative_path = input('command_path', value: '/bin/make')
make_installation_directory = command("hab pkg path #{plan_ident}")
make_full_path = make_installation_directory.stdout.strip + "#{ make_relative_path}"
 
control 'core-plans-make-exists' do
  impact 1.0
  title 'binary should exist'
  desc '
  '
   describe file(make_full_path) do
    it { should exist }
  end
end
