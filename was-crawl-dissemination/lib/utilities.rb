module Dor
  module WASCrawl
    module Dissemination
      class Utilities
        def self.run_sys_cmd(cmd_string, error_message)
          unless system(cmd_string)
            fail "Error in #{error_message} with command: #{cmd_string}\n" + $CHILD_STATUS.to_s
          end
        end

        def self.get_warc_file_list_from_contentMetadata(contentMetadata)
          contentMetadata_xml = Nokogiri::XML(contentMetadata)
          warc_file_list = contentMetadata_xml.xpath("//contentMetadata/resource/file[(@dataType='WARC' or @dataType='ARC') and @shelve='yes']/@id")
          warc_file_list
        end

        def self.get_collection_id(druid_obj)
          collections = druid_obj.collections
          fail "#{druid_obj.id} doesn't belong to a collection" if collections.length == 0

          collection = collections[0]
          collection.id.sub('druid:', '')
        end
      end
    end
  end
end
