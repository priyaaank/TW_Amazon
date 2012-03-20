require File.expand_path(File.dirname(__FILE__) + "../../../spec/support/blueprints.rb")

# our test components
Dir[File.dirname(__FILE__) + '/../components/*.rb'].each {|file| require file}

World(SystemUnderTest)