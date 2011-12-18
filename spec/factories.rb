# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.email                 "hzj@redflag-linux.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :idea do |idea|
  idea.content              "foobar content"
  idea.title		    "foobar title"
  idea.association          :user
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :title do |n|
  "title#{n}"
end
