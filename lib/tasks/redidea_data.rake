namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
   # make_ideas
   # make_likes
  end
end

def make_users
  emails = ['jianxing@redflag-linux.com', 'zhouhuan@redflag-linux.com', 
	  		'sycao@redflag-linux.com','shensuwen@redflag-linux.com']
  password = "abc123"
  emails.each do | email |
    User.create!(:email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_ideas
  User.all.each do |user|
    ('1'..'10').each do |i|
      content = "ssssssssssssssssssssssssssssssssssssssssssssss"
	  title = user.email+i
      user.ideas.create!(:content => content, :title => title)
    end
  end
end

def make_likes
  users = User.all
  user = users.first
  ideas = Idea.all
  #idea = ideas.first
  liking = ideas[11..40]
  #likers = users[3..40]
  liking.each do | liked |
  user.likes.create!(liked.id, 1) 
  end
  #likers.each { |liker| liker.like!(user) }
end
