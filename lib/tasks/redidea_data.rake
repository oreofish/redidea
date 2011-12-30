namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_ideas
  # make_likes
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
    'junhuang@redflag-linux.com',
    'lvlisong@redflag-linux.com',
    'zyzheng@redflag-linux.com',
    'penghao@redflag-linux.com',
    'lingwei@redflag-linux.com',
    'wudi@redflag-linux.com',
    'hanlifei@redflag-linux.com',
    'pengyin@redflag-linux.com',
    'zuohongsheng@redflag-linux.com',
    'jianhuichen@redflag-linux.com',
    'hgfan@redflag-linux.com',
    'wangchao@redflag-linux.com',
    'yushang@redflag-linux.com',
    'zhzhang@redflag-linux.com',
    'sywang@redflag-linux.com',
    'chenjie@redflag-linux.com'
  ]
  password = "abc123"
  emails.each do | email |
    #if not User.find(:first, "email = #{email}")
      User.create!(:email => email,
                   :password => password,
                   :password_confirmation => password)
    #end
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
  Idea.all[11..40].each do | idea |
    user.like!(idea.id, 1) 
  end
  #likers.each { |liker| liker.like!(user) }
end
