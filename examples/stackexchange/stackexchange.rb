require 'restool'
require 'json'

remote_service = Restool.create('stackexchange') do |response, code|
                   begin
                     unless code.to_i == 200
                       raise StandardError, JSON(response)['error_message']
                     end

                     JSON(response)
                   rescue JSON::ParserError
                     raise response
                   end
                 end

user_id = 1677
response = remote_service.get_repos([user_id])

puts "is_employee: #{response.items.first.is_employee}"
puts "reputation: #{response.items.first.reputation}"
