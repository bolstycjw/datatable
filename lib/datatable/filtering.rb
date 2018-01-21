# frozen_string_literal: true

module Datatable
  module Filtering
    extend ActiveSupport::Concern
    include Core

    class_methods do
      attr_reader :filters

      def filter(*names, &block)
        (@filters ||= []) << {
          names: names,
          block: block
        }
      end
    end

    included do
      delegate :filters, to: :class
    end

    def fetch_results
      filters ? filter(super) : super
    end

    def filter(scope)
      filters.each do |filter|
        terms = filter[:names].map { |name| params[name] }.compact
        scope = filter[:block].call(scope, *terms) unless terms.empty?
      end
      scope
    end
  end
end
