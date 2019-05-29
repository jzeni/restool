require 'restool/settings/models'

FactoryBot.define  do
  factory :persistent_connection, class: Restool::Settings::Models::PersistentConnection do
    respool_size    { rand(1..10) }
    want_timeout    { rand(1..100) }
    force_retry     { [true, false].sample }
  end
end
