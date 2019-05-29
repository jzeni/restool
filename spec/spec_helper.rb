# require 'bundler/setup'

require 'rspec'
require 'factory_bot'
require 'rspec/its'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
