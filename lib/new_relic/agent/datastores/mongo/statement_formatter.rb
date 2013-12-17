# encoding: utf-8
# This file is distributed under New Relic's license terms.
# See https://github.com/newrelic/rpm/blob/master/LICENSE for complete details.

require 'new_relic/agent/database'
require 'new_relic/agent/datastores/mongo/obfuscator'

module NewRelic
  module Agent
    module Datastores
      module Mongo
        module StatementFormatter

          PLAINTEXT_KEYS = [
            :database,
            :collection,
            :operation,
            :fields,
            :skip,
            :limit,
            :order
          ]

          OBFUSCATE_KEYS = [
            :selector
          ]

          def self.format(statement)
            result = {}
            PLAINTEXT_KEYS.each do |key|
              result[key] = statement[key] if statement.key?(key)
            end

            OBFUSCATE_KEYS.each do |key|
              if statement.key?(key)
                obfuscated = obfuscate(statement[key])
                result[key] = obfuscated if obfuscated
              end
            end
            result
          end

          def self.obfuscate(statement)
            case NewRelic::Agent::Database.record_sql_method
            when :obfuscated
              Obfuscator.obfuscate_statement(statement)
            when :raw
              statement
            else
              nil
            end
          end
        end
      end
    end
  end
end
