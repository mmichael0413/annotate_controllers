require 'action_dispatch/routing/inspector'

module AnnotateControllers
  class Inspector
    class << self
      def map_all_routes
        all_routes = Rails.application.routes.routes
        inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
        formatter = ActionDispatch::Routing::ConsoleFormatter::Sheet.new
        routes = inspector.format(formatter).split("\n").drop(1)
        remove_constraints(routes).reject(&:empty?)
      end

      def remove_constraints(routes)
        routes.each { |r| r.slice!(/ \{(.*)}/) }
      end
    end
  end
end
