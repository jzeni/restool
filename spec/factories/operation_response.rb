require 'restool/settings/models'

FactoryBot.define  do
  factory :operation_response, class: Restool::Settings::Models::OperationResponse do
    fields   { FactoryBot.build_list(:representation_field, rand(1..10)) }
  end
end
