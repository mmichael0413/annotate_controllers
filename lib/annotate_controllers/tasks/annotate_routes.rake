namespace :annotate_routes do
  task :run => [:environment, :setup] do
    # output = []
    # routes_stream = capture(:stdout) { Rake::Task['routes'].invoke }
    # inspector = AnnotateRoutes::Inspector.new(routes_stream)
    # inspector.routes.each do |route|
    #   begin
    #     AnnotateRoutes::Annotator.new(Rails.root, route).annotate!
    #     output << "#{route[:reqs].gsub(/\#[^\#]*/, '_controller')} annotated"
    #   rescue => e
    #     puts e.message
    #   end
    # end
    # puts output.uniq

    routes = AnnotateRoutes::Inspector.map_routes
    controller_paths = Dir[Rails.root.join('app/controllers/**/*_controller.rb')]
    controller_paths.each do |path|
      raise ControllerNotFound.new(path) unless File.exists?(path)

      File.open(path, 'r+') do |f|
        body = f.read

        raise ActionNotFound.new(@reqs) unless body =~ /def #{action}\W/

        byebug
        new_body = body.gsub(/(?:^ (?: *#.*\n)+)?( *def #{action}\W)/, comment + "\\1")

        f.rewind
        f.write(new_body)
      end
    end
  end

  task :setup do
    # require 'annotate_routes/annotator'
    require 'annotate_routes/inspector'
  end
end

desc 'Annotate routes'
task :annotate_routes => 'annotate_routes:run'
