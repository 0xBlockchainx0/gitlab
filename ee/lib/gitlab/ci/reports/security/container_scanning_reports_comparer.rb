# frozen_string_literal: true

module Gitlab
  module Ci
    module Reports
      module Security
        class ContainerScanningReportsComparer
          include Gitlab::Utils::StrongMemoize

          attr_reader :base_report, :head_report

          def initialize(base_report, head_report)
            @base_report = base_report || ::Gitlab::Ci::Reports::Security::Report.new('container_scanning', '')
            @head_report = head_report
          end

          def added
            strong_memoize(:added) do
              head_report.occurrences - base_report.occurrences
            end
          end

          def fixed
            strong_memoize(:fixed) do
              base_report.occurrences - head_report.occurrences
            end
          end

          def existing
            strong_memoize(:existing) do
              base_report.occurrences & head_report.occurrences
            end
          end
        end
      end
    end
  end
end
