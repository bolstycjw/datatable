# frozen_string_literal: true

require 'test_helper'

class CoreDatatable
  include Datatable::Core

  scope { Foo.all }

  decorate

  column :name
end

class CoreTest < ActiveSupport::TestCase
  setup do
    create_list(:foo, 10)
  end

  test '.columns returns an array' do
    assert_kind_of Array, CoreDatatable.columns
  end

  test '.model_class returns Foo class' do
    assert CoreDatatable.new(nil).model_class == Foo
  end

  test '.default_scope returns filtered scope' do
    assert CoreDatatable.default_scope.call == Foo.all
  end

  test '.decorator returns decorator' do
    assert_kind_of Symbol, CoreDatatable.decorator
  end

  test '#as_json returns a results hash' do
    datatable = CoreDatatable.new(nil)
    data = datatable.results.map do |model|
      { name: "decorated #{model.name}" }
    end
    assert_equal({ recordsTotal: 10, recordsFiltered: 10, data: data },
                 datatable.as_json)
  end
end
