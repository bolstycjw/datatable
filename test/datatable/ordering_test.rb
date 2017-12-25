# frozen_string_literal: true

require 'test_helper'

class OrderingDatatable
  include Datatable::Ordering

  scope Foo.all

  column :name

  order_by :created_at, :desc
end

class OrderingTest < ActiveSupport::TestCase
  setup do
    controller = ActionController::Base.new.tap do |c|
      c.params = { order: { '0' => { column: '0', dir: 'desc' } } }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @datatable = OrderingDatatable.new(view_context)
    create_list(:foo, 10)
  end

  test '#sort_column returns sort column' do
    assert_equal :name, @datatable.sort_column[:name]
  end

  test '#fetch_results returns sorted results' do
    assert_equal Foo.order(name: :desc).to_a, @datatable.fetch_results.to_a
  end
end
