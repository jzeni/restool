require_relative 'restool/settings/loader'
require_relative 'restool/service/restool_service'


module Restool

  def self.create(service_name, &response_handler)
    service_config = Restool::Settings::Loader.load(service_name)

    Restool::Service::RestoolService.new(service_config, response_handler)
  end

end
