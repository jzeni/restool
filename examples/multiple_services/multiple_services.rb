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

puts "Stackexchange response:"
puts "is_employee: #{response.items.first.is_employee}"
puts "reputation: #{response.items.first.reputation}"


remote_service = Restool.create('reqres') do |response, code|
  unless code.to_i == 201
    raise response
  end

  JSON(response)
 end

params = { name: 'morpheus', job: 'leader' }
response = remote_service.create_user(params)

puts "Reqres response:"
puts "id = #{response.id}"
puts "createdAt = #{response.createdAt}"
