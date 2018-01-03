# frozen_string_literal: true

require 'test_helper'

class FooSearchingDatatable
  include Datatable::Searching

  scope { Foo.all }

  column :name
end

class BarSearchingDatatable
  include Datatable::Searching

  scope { Bar.joins(:foo) }

  column :name
  column :foo_name, search: 'foos.name'
end

class SearchingTest < ActiveSupport::TestCase
  setup do
    controller = ActionController::Base.new.tap do |c|
      c.params = { search: { value: 'baz' } }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @foo_datatable = FooSearchingDatatable.new(view_context)
    @bar_datatable = BarSearchingDatatable.new(view_context)
    create_list(:bar, 10)
    create(:bar, foo: create(:foo, name: 'baz'))
  end

  test '#fetch_results returns filtered foo results' do
    assert_equal(Foo.where("name LIKE '%baz%'").to_a,
                 @foo_datatable.fetch_results.to_a)
  end

  test '#fetch_results returns filtered bar results' do
    assert_equal(Bar.joins(:foo).where("foos.name LIKE '%baz%'").to_a,
                 @bar_datatable.fetch_results.to_a)
  end
end
