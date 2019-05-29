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
          value = request_response[field.key]

          object.class.__send__(:attr_accessor, var_name(field))

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

        object.__send__("#{var_name(field)}=", new_value)
      end

      def self.map_complex_field(value, field, object, representations)
        operation_representation = representations[field.type.to_sym]

        new_value = if value.is_a?(Array)
                      value.map { |element| convert(element, operation_representation, representations) }
                    else
                      convert(value, operation_representation, representations)
                    end

        object.__send__("#{var_name(field)}=", new_value)
      end

      def self.var_name(field)
        field.metonym || field.key
      end

      def self.parse_value(type, value)
        case type
        when Restool::Traversal::TRAVERSAL_TYPE_STRING
          value
        when Restool::Traversal::TRAVERSAL_TYPE_INTEGER
          Integer(value)
        when Restool::Traversal::TRAVERSAL_TYPE_DECIMAL
          BigDecimal.new(scalar)
        when Restool::Traversal::TRAVERSAL_TYPE_BOOLEAN
          value.downcase == 'true'
        end
      end

    end

  end
end
