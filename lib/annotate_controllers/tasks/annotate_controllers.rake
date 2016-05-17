namespace :annotate_controllers do
  task run: [:environment, :setup] do
    begin
      AnnotateControllers::Annotator.annotate!
    rescue => e
      puts e.message
    end
  end

  task :setup do
    require 'annotate_controllers/annotator'
    require 'annotate_controllers/inspector'
  end
end

desc 'Annotate controllers'
task annotate_controllers: 'annotate_controllers:run'
