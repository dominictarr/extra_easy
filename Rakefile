		require 'dm_prod'
		require 'model2'

namespace :db do
	task :init do
		initialize_database 
	end

	task :migrate do
		puts "MIGRATING..."
		DataMapper.auto_migrate!
		initialize_database
		puts RbFile.all.inspect
	end
end

namespace :heroku do
	task :deploy do
		puts "DEPLOYING..."
		add = "git add -A"
		commit = "git commit -m 'deploying to heroku'"
		push = "git push heroku master"
		sh add
		sh commit
		sh push
	end
end


task :tests do
	require 'all_tests'
	run_all_tests
end
