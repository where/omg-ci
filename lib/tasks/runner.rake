namespace :omg do
  namespace :ci do
    task :runner => :environment do
      while true
        Suite.all.each do |suite|
          if suite.needs_to_run?
            suite.execute!
          end
        end

        sleep(10)
      end
    end
  end
end
