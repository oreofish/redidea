namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_ideas
    make_likes
  end

end

namespace :db do
  desc "invite users"
  task :invite => :environment do
    make_users
  end

end

def make_users
  emails = [
    'zhouhuan@redflag-linux.com', 
    'jianxing@redflag-linux.com',
    'sycao@redflag-linux.com',
    'shensuwen@redflag-linux.com',
  ]
  password = "abc123"
  emails.each do | email |
    if not User.find(:first, :conditions => "email = '#{email}'")
      User.create!(:email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end

def make_ideas
  User.all.each do |user|
    ('1'..'5').each do |i|
      content = "ssssssssssssssssssssssssssssssssssssssssssssss"
	  title = user.email+i
      user.ideas.create!(:content => content, :title => title)
    end
  end
end

def make_likes
  users = User.all
  user = users.first
  Idea.all[6..20].each do | idea |
    user.like!(idea.id, 1) 
  end
  #likers.each { |liker| liker.like!(user) }
end
