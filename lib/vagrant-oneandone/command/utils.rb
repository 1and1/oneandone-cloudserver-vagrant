require 'fog-oneandone'
require 'terminal-table'

module VagrantPlugins
  module OneAndOne
    module Command
      module Utils
        def fog_oneandone(token)
          api_key = token ? token : ENV['ONEANDONE_API_KEY']

          raise Errors::NoApiKeyError unless api_key

          params = {
            oneandone_api_key: api_key
          }

          Fog::Compute::OneAndOne.new params
        end

        def display_table(env, headers, rows)
          table = Terminal::Table.new headings: headers, rows: rows
          if env.respond_to?('ui')
            env.ui.info(table.to_s)
          else
            env[:ui].info(table.to_s)
          end
        end
      end
    end
  end
end
