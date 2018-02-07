# frozen_string_literal: true

module Datatable
  module ActionViewExtensions
    module TableHelper
      def datatable_for(datatable, url: nil, **options)
        html_options = options.delete(:html_options) || {}
        columns_options = datatable.columns.map do |col|
          { data: col[:name], **col[:options] }
        end
        datatable_instance = datatable.new(self)
        actions = datatable.actions&.map do |action|
          byebug
          p send(action[:path], *action[:path_args], **action[:path_params])
          {
            name: action[:name],
            path: send(action[:path], *action[:path_args], **action[:path_params])
          }
        end
        url = url || polymorphic_path(datatable_instance.model_class,
                                      format: :json)
        datatable_options = {
          actions: actions,
          processing: true,
          'server-side': true,
          columns: columns_options,
          url: url,
          order: datatable.default_order,
          **options
        }
        tag.table(
          role: 'datatable',
          data: datatable_options,
          **html_options
        ) do
          thead_tag(*datatable.columns) do |column|
            concat tag.th(column[:header] || column[:name].to_s.humanize)
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
