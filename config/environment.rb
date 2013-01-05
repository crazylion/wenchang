# Load the rails application
require File.expand_path('../application', __FILE__)
require File.expand_path("lib/delayed_rake.rb")

# Initialize the rails application
Wenchang::Application.initialize!
