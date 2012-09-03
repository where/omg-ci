namespace :omg do
  namespace :ci do
    task :runner => :environment do
      while true
        Suite.all.each do |suite|
          if suite.needs_to_run?
            suite.execute!
          end
        end

        Project.all.each do |proj|
          Bundler.with_clean_env do
            puts "Running OMG_PULL_REQUEST: #{proj.name}"
            dir = Stage.dir(proj.name) 
            command = "cd #{dir} && DAEMON=false omg_pull_request"
            puts command
            puts `#{command}`
          end
        end
        sleep(10)
      end
    end
  end
end
