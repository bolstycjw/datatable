# frozen_string_literal: true

require 'test_helper'

class PaginatingDatatable
  include Datatable::Paginating

  scope Foo.all

  column :name
end

class PaginatingTest < ActiveSupport::TestCase
  setup do
    controller = ActionController::Base.new.tap do |c|
      c.params = { start: '0', length: '10' }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @datatable = PaginatingDatatable.new(view_context)
    create_list(:foo, 20)
  end

  test '#records_filtered returns filtered count' do
    assert_equal 20, @datatable.records_filtered
  end

  test '#fetch_results returns paginated results' do
    assert_equal Foo.all.page(1).per(10).to_a, @datatable.fetch_results.to_a
  end
end
