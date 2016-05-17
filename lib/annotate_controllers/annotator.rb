require 'annotate_controllers/exceptions'

module AnnotateControllers
  class Annotator

    class << self

      def annotate!
        mapped_routes = routes
        pattern = /.*\/controllers\/(.*)\_controller\./
        controller_paths = Dir[Rails.root.join('app/controllers/**/*_controller.rb')]

        controller_paths.each do |path|
          raise ControllerNotFound.new(path) unless File.exists?(path)

          controller_name = pattern.match(path)[-1] # ignore match for entire filename

          lines = []
          IO.readlines(path).each_with_index do |line, index|
            action_name = /def\W(.*)/.match(line).try(:[], -1)

            if action_name && match = mapped_routes.detect{ |r|
                r[:controller] == controller_name &&
                r[:action] == action_name
              }
              # replace any comment above method
              if lines[index - 1] =~ /\#/
                lines[index - 1] = comment(match)
              # otherwise, insert comment above method
              else
                lines << comment(match)
              end
            end

            lines << line
          end

          File.open(path, 'w') do |file|
            file.puts lines
          end

          puts "Annotated #{controller_name}_controller"
        end
      end

      def comment(match)
        "\t# #{match[:prefix]} #{match[:verb]} #{trim(match[:uri])}\n"
      end

      def routes
        mapped_routes = []
        AnnotateControllers::Inspector.map_all_routes.each do |route|
          r = route.split(' ')
          contraction = r[-1].split('#') # controller, action, controlleraction...
          mapped_routes << {
            prefix: r.size > 3 ? r.try(:[], 0) : nil,
            verb: r.size > 3 ? r[1] : r[0],
            uri: r.size > 3 ? r[2] : r[1],
            controller: contraction.first,
            action: contraction.last
          }
        end
        mapped_routes
      end

      # Removes (.:format) from URI pattern string
      def trim(string)
        string.slice! '(.:format)'
        string
      end

    end

  end
end
