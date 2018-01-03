# frozen_string_literal: true

module Datatable
  module Core
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :columns, :decorator, :default_scope

      def column(column_name, order: nil, **options, &block)
        block ||= ->(model) { model.send(column_name) }
        @columns ||= []
        @columns << {
          name: column_name,
          order: order,
          options: options,
          block: block
        }
      end

      def decorate(&block)
        if block_given?
          @decorator = block
        else
          @decorator = :decorate
        end
      end

      def model_class
        @model_class ||= default_scope.name.constantize
      end

      def model_table_name
        model_class.table_name
      end

      def scope
        @default_scope = yield
      end
    end

    included do
      delegate(:columns,
               :decorator,
               :default_scope,
               :model_class,
               :model_table_name,
               to: :class)
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
        model = decorate(model) if decorator
        {}.tap do |obj|
          columns.each do |col|
            content = @view.instance_exec(model, &col[:block])
            obj[col[:name]] = content
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

    private

      def decorate(model)
        decorator.respond_to?(:call) ? decorator.call(model) : model.decorate
      end
  end
end
