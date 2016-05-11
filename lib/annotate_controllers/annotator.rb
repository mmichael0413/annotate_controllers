require 'annotate_controllers/exceptions'

module AnnotateControllers
  class Annotator

    def initialize(root, route)
      @root = root
      @reqs = route.fetch(:reqs)
      @info = route.fetch(:info)
    end

    def annotate!
      raise ControllerNotFound.new(controller_file_path) unless File.exists?(controller_file_path)

      File.open(controller_file_path, 'r+') do |f|
        body = f.read

        raise ActionNotFound.new(@reqs) unless body =~ /def #{action}\W/

        byebug
        new_body = body.gsub(/(?:^ (?: *#.*\n)+)?( *def #{action}\W)/, comment + "\\1")

        f.rewind
        f.write(new_body)
      end
    end

    def comment
      [ *@info.map {|i| i.join(' ')} ].map {|c| "  # " + trim(c) }.join("\n") + "\n"
    end

    def controller_file_path
      @root.join("app/controllers/#{controller}_controller.rb")
    end

    def controller
      @controller ||= @reqs.split('#').first
    end

    def action
      @action ||= @reqs.split('#').last
    end

    # Removes (.:format) from URI pattern string
    def trim(string)
      string.slice! '(.:format)'
      string
    end
  end
end
