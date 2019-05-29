require 'restool/settings/models'

FactoryBot.define  do
  factory :representation, class: Restool::Settings::Models::Representation do
    name     { 'name' }
    fields   { FactoryBot.build_list(:representation_field, rand(1..10)) }
  end
end
