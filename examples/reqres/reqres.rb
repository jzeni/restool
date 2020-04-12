require 'restool'
require 'json'

remote_service = Restool.create('reqres') do |response, code|
                  unless code.to_i == 201
                    raise response
                  end

                  JSON(response)
                 end

params = { name: 'morpheus', job: 'leader' }
response = remote_service.create_user(params)

puts "id = #{response.id}"
puts "createdAt = #{response.createdAt}"
