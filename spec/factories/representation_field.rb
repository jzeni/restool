require 'restool/settings/models'

FactoryBot.define  do
  factory :representation_field, class: Restool::Settings::Models::RepresentationField do
    key     { 'name' }
    metonym { 'metonym_of_name' }
    type    { ['string', 'integer'].sample }
  end
end
