namespace :omg do
  namespace :ci do
    task :runner => :environment do
      Rails.cache.clear
      while true
        Suite.all.each do |suite|
          if suite.project && suite.needs_to_run?
            suite.execute!
          end
        end

        Project.omg_pull_request.each do |proj|
          puts "omg"
          next unless proj.name.match(/sms/)
          config = OmgPullRequest::Configuration.new(
            :local_repo => Stage.dir(proj.name)
          )

          OmgPullRequest::TestRunner.start_daemon(config, false)
        end
        sleep(60)
      end
    end
  end
end
