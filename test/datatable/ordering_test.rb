# frozen_string_literal: true

require 'test_helper'

class FooOrderingDatatable
  include Datatable::Ordering

  scope { Foo.all }

  column :name

  order_by :created_at, :desc
end

class BarOrderingDatatable
  include Datatable::Ordering

  scope { Bar.includes(:foo).references(:foo) }

  column :name, order: 'foos.name'

  order_by :created_at, :desc
end

class OrderingTest < ActiveSupport::TestCase
  setup do
    controller = ActionController::Base.new.tap do |c|
      c.params = { order: { '0' => { column: '0', dir: 'desc' } } }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @foo_datatable = FooOrderingDatatable.new(view_context)
    @bar_datatable = BarOrderingDatatable.new(view_context)
    create_list(:foo, 10)
    create_list(:bar, 10)
  end

  test '#sort_column returns sort column' do
    assert_equal :name, @foo_datatable.send(:sort_column)[:name]
  end

  test '#fetch_results returns sorted results' do
    assert_equal Foo.order(name: :desc).to_a, @foo_datatable.fetch_results.to_a
  end

  test '#fetch_results for custom order returns sorted results' do
    assert_equal(
      Bar.joins(:foo).order('foos.name desc').to_a,
      @bar_datatable.fetch_results.to_a
    )
  end
end
