namespace :setup_function do
    desc 'rebuild cloud function infras'
    task :run do
      on roles(:all) do
        execute 'cd ~/aws_mongo_export/current/setup_gcp_function; cp ./data.tf ./deploy; cp ./main.tf ./deploy; cd deploy; terraform destroy -auto-approve; terraform apply -auto-approve'
      end
    end
end