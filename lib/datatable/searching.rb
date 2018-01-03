# frozen_string_literal: true

module Datatable
  module Searching
    extend ActiveSupport::Concern
    include Core

    def fetch_results
      search(super)
    end

    def search(scope)
      term = params[:search][:value]
      search_string = []
      columns.select(&method(:searchable?)).each do |col|
        query = col[:search] || "#{model_class.table_name}.#{col[:name]}"
        search_string << "#{query} LIKE :search"
      end
      scope.where(search_string.join(' or '), search: "%#{term}%")
    end

    private

      def searchable?(column)
        column[:searchable] && (column[:search] || text_column?(column[:name]))
      end

      def text_column?(column_name)
        %i[string text].include?(
          model_class.column_for_attribute(column_name).type
        )
      end
  end
end
