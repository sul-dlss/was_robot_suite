# frozen_string_literal: true

module Robots
  module DorRepo
    module WasCrawlDissemination
      class CdxjMerge < Base
        def initialize
          super('wasCrawlDisseminationWF', 'cdxj-merge')
        end

        def perform_work
          Dor::WasCrawl::CdxjMergeService.merge(druid_id: druid)
        end
      end
    end
  end
end
