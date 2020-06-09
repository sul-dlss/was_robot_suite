module Dor
  module WASCrawl
    module Dissemination
      class Utilities
        def self.run_sys_cmd(cmd_string, error_message)
          unless system(cmd_string)
            fail "Error in #{error_message} with command: #{cmd_string}\n" + $CHILD_STATUS.to_s
          end
        end

        # @param [Cocina::Models::DRO] cocina_model
        # @return [Array<String>] a list of filenames that are ARCs or WARCs
        def self.warc_file_list(cocina_model)
          cocina_model.structural.contains.flat_map do |file_set|
            file_set.structural.contains.select do |file|
              filename = file.filename.downcase
              file.administrative.shelve &&
                (filename.ends_with?('.arc.gz') ||
                filename.ends_with?('.warc.gz') ||
                filename.ends_with?('.warc'))
            end.map(&:filename)
          end
        end

        def self.get_collection_id(druid_obj)
          Dor::WASCrawl::Utilities.get_collection_id(druid_obj)
        end
      end
    end
  end
end
