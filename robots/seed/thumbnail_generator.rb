module Robots
  module DorRepo
    module WasSeedPreassembly
      class ThumbnailGenerator
        include LyberCore::Robot

        def initialize
          super('dor', 'wasSeedPreassemblyWF', 'thumbnail-generator')
        end

        def perform(druid)
          workspace_path = Dor::Config.was_seed.workspace_path
          LyberCore::Log.info "Creating ThumbnailGenerator with parameters #{druid}"

          druid_tree_directory = DruidTools::Druid.new(druid, workspace_path)
          metadata_xml_input   = Nokogiri::XML(File.read("#{druid_tree_directory.content_dir}/source.xml"))
          uri = metadata_xml_input.xpath('//item/uri').text

          Dor::WASSeed::ThumbnailGeneratorService.capture_thumbnail(druid, workspace_path, uri)

       end
      end
    end
  end
end
