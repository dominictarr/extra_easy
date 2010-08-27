namespace :db do
	task :migrate do
		puts "MIGRATING..."
		require 'dm_prod'
		require 'model2'
		DataMapper.auto_migrate!
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

