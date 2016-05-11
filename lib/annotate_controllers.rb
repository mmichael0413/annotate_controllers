require 'annotate_controllers/version'

module AnnotateControllers
  class Railtie < ::Rails::Railtie
    rake_tasks do
      require 'annotate_controllers/tasks'
    end
  end
end
