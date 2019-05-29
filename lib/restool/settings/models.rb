module Restool
  module Settings
    module Models

      Operation = Struct.new(:name, :path, :method, :uri_params, :response)
      OperationResponse = Struct.new(:fields)
      Service = Struct.new(:name, :host, :operations, :persistent, :timeout, :representations, :basic_auth, :verify_ssl)
      Representation = Struct.new(:name, :fields)
      RepresentationField = Struct.new(:key, :metonym, :type)
      BasicAuthentication = Struct.new(:user, :password)
      PersistentConnection = Struct.new(:respool_size, :want_timeout, :force_retry)
      OperationResponsField = RepresentationField

    end
  end
end
