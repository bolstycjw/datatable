# frozen_string_literal: true

module Datatable
  module Paginating
    extend ActiveSupport::Concern

    def paginate(scope)
      scope.page(page).per(per_page)
    end

    private

      def page
        params[:start].to_i / per_page + 1
      end

      def per_page
        params[:length].to_i.positive? ? params[:length].to_i : 10
      end
  end
end
