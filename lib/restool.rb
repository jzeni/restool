require_relative 'restool/settings/loader'
require_relative 'restool/service/restool_service'

module Restool

  def self.create(service_name, opts = {}, &response_handler)
    service_config = Restool::Settings::Loader.load(service_name, opts)

    Restool::Service::RestoolService.new(service_config, response_handler)
  end

end
