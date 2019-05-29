require 'restool/settings/models'

FactoryBot.define  do
  factory :operation, class: Restool::Settings::Models::Operation do
    name        { 'name' }
    path        { '/users/:id' }
    uri_params  { 'id' }
    association :response, factory: :operation_response

    # `method` is a reserved word
    add_attribute(:method)      { ['post', 'get'].sample }
  end
end
