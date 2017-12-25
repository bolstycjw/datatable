# frozen_string_literal: true

require 'kaminari'

module Datatable
  module Paginating
    extend ActiveSupport::Concern
    include Core

    def fetch_results
      paginate(super)
    end

    def paginate(scope)
      scope.page(page).per(per_page)
    end

    def records_filtered
      results.total_count
    end

    def page
      params[:start].to_i / per_page + 1
    end

    def per_page
      params[:length].to_i.positive? ? params[:length].to_i : 10
    end
  end
end
