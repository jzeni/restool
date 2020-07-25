require 'restool/settings/models'

FactoryBot.define  do
  factory :service, class: Restool::Settings::Models::Service do
    name            { 'name' }
    url             { 'http://hello.com' }
    operations      { FactoryBot.build_list(:operations) }
    timeout         { rand(1..100) }
    representations { FactoryBot.build_list(:representation) }
    association     :basic_auth, factory: :basic_authentication
    verify_ssl      { [true, false].sample }
  end
end
