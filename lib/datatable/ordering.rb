# frozen_string_literal: true

module Datatable
  module Ordering
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :default_order

      def order_by(name, sort_direction)
        sort_index = columns.find_index { |col| col[:name] == name }
        @default_order = [sort_index, sort_direction]
      end
    end

    def sort(scope)
      return scope unless (order = sort_column[:order])
      if order.respond_to?(:call)
        order.call(scope)
      else
        scope.order("#{sort_column[:name]} #{sort_direction}")
      end
    end

    private

      def sort_column
        columns[params[:order]['0'][:column].to_i]
      end

      def sort_direction
        params[:order]['0'][:dir] == 'desc' ? 'DESC' : 'ASC'
      end
  end
end
