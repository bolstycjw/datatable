# frozen_string_literal: true

module Datatable
  module Core
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :columns, :decorator, :default_scope

      def column(column_name, order: true, search: false, &block)
        block ||= ->(model) { model.send(column_name) }
        @columns ||= []
        @columns << {
          name: column_name,
          order: order,
          search: search,
          block: block
        }
      end

      def decorate(&block)
        @decorator = block
      end

      def model_class
        @model_class ||= default_scope.name.constantize
      end

      def scope
        @default_scope = yield
      end
    end

    included do
      delegate :columns, :decorator, :default_scope, :model_class, to: :class
      delegate :params, to: :@view
    end

    def initialize(view)
      @view = view
    end

    def as_json(_options = {})
      {
        recordsTotal: model_class.count,
        recordsFiltered: records_filtered,
        data: data
      }
    end

    def data
      results.map do |model|
        model = decorator.call(model) if decorator
        [].tap do |row|
          columns.each do |col|
            content = @view.instance_exec(model, &col[:block])
            row << content
          end
        end
      end
    end

    def results
      @results ||= fetch_results
    end

    def records_filtered
      model_class.count
    end

    def fetch_results
      default_scope
    end
  end
end
