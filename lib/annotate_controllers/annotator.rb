require 'annotate_controllers/errors'

module AnnotateControllers
  class Annotator

    class << self

      VERBS = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']

      def annotate!
        rake_output = []
        mapped_routes = routes
        pattern = /.*\/controllers\/(.*)\_controller\./
        controller_paths = Dir[Rails.root.join('app/controllers/**/*_controller.rb')]

        controller_paths.each do |path|
          raise ControllerNotFound.new(path) unless File.exist?(path)

          lines = []
          prefixes = []
          controller_name = pattern.match(path)[-1] # ignore match for entire filename
          original_file_digest = Digest::SHA1.hexdigest(File.read(path))

          IO.readlines(path).each do |line|
            action_name = /def\W(.*)/.match(line).try(:[], -1)

            if action_name && matches = select_routes_from_method(mapped_routes, controller_name, action_name)
              matches.each do |match|
                # add matched line to global array in order to reuse prefixes
                prefixes << { action: action_name, prefix: match[:prefix] }
                # replace existing annotation (if exists)
                if overwrite_self?(match[:verb], lines[-1])
                  lines[-1] = comment(prefixes, match)
                # otherwise, insert comment
                else
                  lines << comment(prefixes, match)
                end
              end
            end

            lines << line
          end

          File.open(path, 'w') do |file|
            file.puts lines
          end

          new_file_digest = Digest::SHA1.hexdigest(File.read(path))
          rake_output << "Annotated #{controller_name}_controller" unless original_file_digest == new_file_digest
        end

        puts rake_output.any? ? rake_output : 'Nothing annotated'
      end

      def select_routes_from_method(routes, controller, action)
        results = routes.select{ |r|
          r[:controller] == controller && r[:action] == action
        }
        results.any? ? results : nil
      end

      def comment(prefixes, match)
        "\t# #{match[:verb]} #{trim(match[:uri])}"\
        "#{prefix_or_shared(prefixes, match[:verb], match[:prefix], match[:action])}\n"
      end

      def prefix_or_shared(prefixes, verb, prefix, action)
        if prefix.present?
          ' (' + prefix + '_path)'
        else
          shared_prefix(prefixes, verb, action)
        end
      end

      def shared_prefix(prefixes, verb, action)
        if VERBS.include? verb
          ' (' +
          prefixes.detect{ |l| l[:action] == shared_action_prefix(action) }.try(:[], :prefix) +
          '_path)'
        else
          ''
        end
      end

      def shared_action_prefix(action)
        case action
        when 'create'
          'index'
        when 'update'
          'show'
        when 'destroy'
          'show'
        end
      end

      def overwrite_self?(verb, line)
        "# #{verb}" == /(\#\s\w*)/.match(line).try(:[], 0)
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
