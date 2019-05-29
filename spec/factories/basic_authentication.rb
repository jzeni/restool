require 'restool/settings/models'

FactoryBot.define  do
  factory :basic_authentication, class: Restool::Settings::Models::BasicAuthentication do
    user     { 'user' }
    password { 'asd123' }
  end
end
