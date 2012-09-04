namespace :omg do
  namespace :ci do
    task :runner => :environment do
      Rails.cache.clear
      while true
        puts "running tests"
        Suite.all.each do |suite|
          puts "Suite: #{suite.id} #{suite.project.inspect}"
          #TODO: when destroying a project remove suites
          if suite.project && suite.needs_to_run?
            puts "executing"
            suite.execute!
          end
        end

        puts "running wherebot"
        # TODO: add a flag if support omg_pull_request
        Project.all.each do |proj|
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
