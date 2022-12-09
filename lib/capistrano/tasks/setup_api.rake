namespace :setup_api do
    desc 'restart mongo-export-api'
    task :run do
      on roles(:all) do
        execute 'sudo systemctl restart mongo-export-api.service'
      end
    end
end