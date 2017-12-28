# frozen_string_literal: true

module Datatable
  module ActionViewExtensions
    module TableHelper
      def datatable_for(datatable:, url:)
        tag.table(
          role: 'datatable',
          class: 'table table-bordered w-100',
          data: {
            columns: datatable.columns.map do |col|
              { data: col[:name], **col[:options] }
            end,
            url: url,
            order: datatable.default_order
          }
        ) do
          thead_tag(*datatable.columns) do |column|
            concat tag.th(column[:name].to_s.humanize)
          end
        end
      end

      private

        def thead_tag(*attributes)
          tag.thead do
            tag.tr { attributes.each { |attribute| yield(attribute) } }
          end
        end
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include Datatable::ActionViewExtensions::TableHelper
end
