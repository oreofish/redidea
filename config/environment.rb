# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Redidea::Application.initialize!

#Record user info
$my_logger = Logger.new("log/userinfo.log")

