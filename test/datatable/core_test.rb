# frozen_string_literal: true

require 'test_helper'

class CoreDatatable
  include Datatable::Core

  scope Foo.where(name: 'foo')

  column :name
end

class CoreTest < ActiveSupport::TestCase
  setup do
    Foo.create!(name: 'foo')
    Foo.create!(name: 'bar')
  end

  test '.columns returns an array' do
    assert_kind_of Array, CoreDatatable.columns
  end

  test '.model_class returns Foo class' do
    assert CoreDatatable.model_class == Foo
  end

  test '.default_scope returns filtered scope' do
    assert CoreDatatable.default_scope == Foo.where(name: 'foo')
  end

  test '#as_json returns a results hash' do
    assert_equal({ recordsTotal: 2, recordsFiltered: 2, data: [['foo']] },
                 CoreDatatable.new(nil).as_json)
  end
end
