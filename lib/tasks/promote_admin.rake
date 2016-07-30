task :promote_admin => :environment do
  user = User.first
  if user
    user.update_attributes(admin: true, active: true)
  else
    puts 'Unable to find a valid user to make admin.'
  end
end