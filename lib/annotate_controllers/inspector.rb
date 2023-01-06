require 'action_dispatch/routing/inspector'

module AnnotateControllers
  class Inspector

    class << self

      def map_all_routes
        all_routes = Rails.application.routes.routes
        inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
        remove_constraints(
          inspector.format(ActionDispatch::Routing::ConsoleFormatter::Sheet.new).split("\n").drop(1)
        )
      end

      def remove_constraints(routes)
        routes.each{ |r| r.slice!(/ \{(.*)}/) }
      end

    end

  end
end
