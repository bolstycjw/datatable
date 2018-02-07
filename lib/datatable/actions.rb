# frozen_string_literal: true

module Datatable
  module Actions
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :actions

      def action(name, path)
        (@actions ||= []) << { name: name, path: path }
      end
    end

    included do
      delegate :actions, to: :class
    end
  end
end
