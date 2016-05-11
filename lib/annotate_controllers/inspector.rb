require 'action_dispatch/routing/inspector'

module AnnotateControllers
  class Inspector

    class << self

      def map_all_routes
        all_routes = Rails.application.routes.routes
        inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
        inspector.format(ActionDispatch::Routing::ConsoleFormatter.new).split("\n")
      end

    end

  end
end
