module Restool
  module Settings
    module Models

      Operation = Struct.new(:name, :path, :method, :uri_params, :response)
      OperationResponse = Struct.new(:fields)
      Service = Struct.new(:name, :host, :operations, :timeout, :representations, :basic_auth, :verify_ssl, :opts)
      Representation = Struct.new(:name, :fields)
      RepresentationField = Struct.new(:key, :metonym, :type)
      BasicAuthentication = Struct.new(:user, :password)
      OperationResponsField = RepresentationField

    end
  end
end
