# frozen_string_literal: true

require 'test_helper'

class SearchingDatatable
  include Datatable::Searching

  scope { Foo.all }

  column :name
end

class SearchingTest < ActiveSupport::TestCase
  setup do
    controller = ActionController::Base.new.tap do |c|
      c.params = { search: { value: '3' } }
    end
    view_context = ActionView::Base.new(nil, {}, controller)
    @datatable = SearchingDatatable.new(view_context)
    create_list(:foo, 10)
  end

  test '#fetch_results returns filtered results' do
    assert_equal(Foo.where("name LIKE '%3%'").to_a,
                 @datatable.fetch_results.to_a)
  end
end
