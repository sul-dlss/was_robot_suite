module Dor
  module WasCrawl
    module Dissemination
      class Utilities
        def self.run_sys_cmd(cmd_string, error_message)
          raise "Error in #{error_message} with command: #{cmd_string}\n" + $CHILD_STATUS.to_s unless system(cmd_string)
        end

        # @param [Cocina::Models::DRO] cocina_model
        # @return [Array<String>] a list of filenames that are ARCs or WARCs
        def self.warc_file_list(cocina_model)
          file_list(cocina_model, ['.arc.gz', '.warc.gz', '.warc'])
        end

        # @param [Cocina::Models::DRO] cocina_model
        # @return [Array<String>] a list of filenames that are WACZs
        def self.wacz_file_list(cocina_model)
          file_list(cocina_model, ['.wacz'])
        end

        def self.file_list(cocina_model, file_extensions)
          cocina_model.structural.contains.flat_map do |file_set|
            file_set.structural.contains.select do |file|
              filename = file.filename.downcase
              file.administrative.shelve && file_extensions.any? { |file_extension| filename.ends_with?(file_extension) }
            end.map(&:filename)
          end
        end

        def self.get_collection_id(druid_obj)
          Dor::WasCrawl::Utilities.get_collection_id(druid_obj)
        end
      end
    end
  end
end
