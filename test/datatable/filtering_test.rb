# frozen_string_literal: true

require 'test_helper'

class BarFilteringDatatable
  include Datatable::Filtering

  scope { Bar }

  filter(:foo, :name) do |scope, foo, name|
    scope.where(foo: foo).where('name LIKE ?', "%#{name}%")
  end

  column :name
end

class FilteringTest < ActiveSupport::TestCase
  setup do
    @foo = create(:foo)
    @bar = create(:bar, name: 'baz', foo: @foo)
    create_list(:bar, 10)
    controller = ActionController::Base.new.tap do |c|
      c.params = { foo: @foo.id, name: @bar.name }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @bar_datatable = BarFilteringDatatable.new(view_context)
  end

  test '#fetch_results returns filtered bar results' do
    assert_equal(Bar.where(foo: @foo).where('name LIKE ?', "%#{@bar.name}%").to_a,
                 @bar_datatable.fetch_results.to_a)
  end
end
