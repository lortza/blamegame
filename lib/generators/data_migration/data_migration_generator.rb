# frozen_string_literal: true

class DataMigrationGenerator < Rails::Generators::NamedBase
  def create_data_migration_file
    timestamp = Time.zone.now.to_s.tr('^0-9', '')[0..13]
    filepath = "db/migrate/#{timestamp}_#{file_name}.rb"

    create_file filepath, <<~FILE
      # frozen_string_literal: true

      class #{class_name} < ActiveRecord::Migration[6.0]
        def up
          # Your code here
          data_check
        end

        def down
          # Your code here
        end

        def data_check
          # Write a query that ensures your `up` method has the expected outcome.

          expected_results = nil
          raise "DATA MIGRATION FAILED" unless expected_results.present?
        end
      end
    FILE
  end
end
