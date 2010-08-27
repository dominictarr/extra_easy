namespace :db do
	task :migrate do
		puts "MIGRATING..."
		require 'dm_prod'
		require 'model2'
		DataMapper.auto_migrate!
	end
end
