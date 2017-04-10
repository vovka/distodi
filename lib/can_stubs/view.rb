module CanStubs
  module View
    module ClassMethods
    end

    module InstanceMethods
      def can?(action, resource)
        current_user.can?(action, resource)
      end

      private

        def current_user
          super || current_company
        end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
