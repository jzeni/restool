require 'bigdecimal'

require_relative 'object'

module Restool
  module Traversal

    TRAVERSAL_TYPE_STRING    = :string
    TRAVERSAL_TYPE_INTEGER   = :integer
    TRAVERSAL_TYPE_DECIMAL   = :decimal
    TRAVERSAL_TYPE_BOOLEAN   = :boolean

    TRAVERSAL_TYPES = [
      TRAVERSAL_TYPE_STRING, TRAVERSAL_TYPE_INTEGER, TRAVERSAL_TYPE_DECIMAL, TRAVERSAL_TYPE_BOOLEAN
    ]

    module Converter

      def self.convert(request_response, response_representation, representations)
        object = Restool::Traversal::Object.new

        object.class.__send__(:attr_accessor, :_raw)
        object.__send__("_raw=", request_response)

        if request_response.is_a?(Array)
          request_response.map do |element|
            map_response_to_representation(response_representation, element, object, representations)
          end
        else
          map_response_to_representation(response_representation, request_response, object, representations)
        end
      end

      private

      def self.map_response_to_representation(representation, request_response, object, representations)
        representation.fields.each do |field|
          value = request_response[field.key.to_s] || request_response[field.key.to_sym]

          object.class.__send__(:attr_accessor, var_name(field))

          if value.nil?
            set_var(object, field, nil)
            next
          end

          if Restool::Traversal::TRAVERSAL_TYPES.include?(field.type.to_sym)
            map_primitive_field(value, field, object)
          else
            map_complex_field(value, field, object, representations)
          end
        end

        object
      end

      def self.map_primitive_field(value, field, object)
        new_value = if value.is_a?(Array)
                      value.map { |element| parse_value(field.type, element) }
                    else
                      parse_value(field.type, value)
                    end

        set_var(object, field, new_value)
      end

      def self.map_complex_field(value, field, object, representations)
        operation_representation = representations[field.type.to_sym]

        new_value = if value.is_a?(Array)
                      value.map { |element| convert(element, operation_representation, representations) }
                    else
                      convert(value, operation_representation, representations)
                    end

        set_var(object, field, new_value)
      end

      def self.set_var(object, field, new_value)
        object.__send__("#{var_name(field)}=", new_value)
      end

      def self.var_name(field)
        field.metonym || field.key
      end

      def self.parse_value(type, value)
        case type
        when Restool::Traversal::TRAVERSAL_TYPE_STRING
          value.to_s
        when Restool::Traversal::TRAVERSAL_TYPE_INTEGER
          Integer(value)
        when Restool::Traversal::TRAVERSAL_TYPE_DECIMAL
          value.to_s.to_f
        when Restool::Traversal::TRAVERSAL_TYPE_BOOLEAN
          value.to_s.downcase == 'true'
        end
      end

    end

  end
end
