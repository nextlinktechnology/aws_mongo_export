namespace :setup_env do
    desc 'setup .envfiles'
    task :run do
      on roles(:all) do
        execute 'cd ~/aws_mongo_export/current; sudo chmod 764 ./setup_env.sh; ./setup_env.sh'
      end
    end
end