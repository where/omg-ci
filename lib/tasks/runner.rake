namespace :omg do
  namespace :ci do
    task :runner => :environment do
      while true
        Suite.all.each do |suite|
          puts "Suite: #{suite.id} #{suite.project.inspect}"
          if suite.project && suite.needs_to_run?
            puts "executing"
            #suite.execute!
          end
        end

        Project.all.each do |proj|
          config = OmgPullRequest::Configuration.new(
            :local_repo => Stage.dir(proj.name)
          )

          OmgPullRequest::TestRunner.start_daemon(config, false)
        end
        sleep(10)
      end
    end
  end
end
