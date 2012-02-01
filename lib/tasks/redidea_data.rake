# encoding: utf-8
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_ideas
    make_likes
    make_activities
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
      content = "aaa bbb ccc ddd eee"
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

def make_activities
  user = User.first
  user.activities.create(:name => '最佳商业创意奖', :describe => '红点子大赛')
  user.activities.create(:name => '最佳商业计划奖', :describe => '红点子大赛计划奖')
  user.activities.create(:name => 'Todo', :describe => 'My todo list')
end
