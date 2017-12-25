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
        search_string << "#{model_class.table_name}.#{col[:name]} LIKE :search"
      end
      results = scope.where(search_string.join(' or '),
                          search: "%#{term}%")
      methods
        .select { |method| method.to_s.starts_with?('search_by') }
        .each { |method| results = results.or(send(method, scope, term)) }
      results
    end

    private

      def searchable?(column)
        model_class.column_for_attribute(column[:name]).type == :string
      end
  end
end
