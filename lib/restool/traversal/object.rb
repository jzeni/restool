module Restool
  module Traversal
    class Object

      def to_hash
        instance_variables
          .inject({}) do |acum, var|
            acum[var.to_s.delete('@')] = instance_variable_get(var)
            acum
          end
      end

      alias_method :to_h, :to_hash

    end
  end
end
