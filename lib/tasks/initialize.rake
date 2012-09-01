namespace :omg do
  namespace :ci do
    task :initialize => :environment do
      print "email: "
      email = STDIN.gets
      password = UUID.generate(:compact)

      user = User.create_user(email, password, 'admin')  

      if user.invalid?
        puts "Unable to initialize user: #{user.errors.to_json}"
      else
        puts "User with password #{password} created."
      end
    end
  end
end
