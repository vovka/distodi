module CanStubs
  module Model
    module ClassMethods
    end

    module InstanceMethods
      def can?(action, resource)
        case resource
        when Service
          case action.to_sym
          when :delete
            resource.user == self && (
              resource.self_approvable?() || resource.requires_action?
            )
          when :approve, :decline
            resource.approver?(self) && resource.requires_action?
          end
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end
