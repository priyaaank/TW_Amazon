puts 'SETTING UP TEST ADMIN LOGIN'

@index = 1

2.times do
  user = User.new(:username => "Admin_tw_#{@index}", :admin => true, :email=> nil, :password => 'adminpass', :password_confirmation => 'adminpass')
  if(user.save!)
    puts 'New admin created: ' << user.username
    @index += 1
  end
end

puts 'SETTING UP TEST USER LOGIN'

@index = 1

10.times do
  user = User.new(:username => "User_tw_#{@index}", :admin => false, :email=> nil, :password => 'userpass', :password_confirmation => 'userpass')
  if(user.save!)
    puts 'New user created: ' << user.username
    @index += 1
  end
end

