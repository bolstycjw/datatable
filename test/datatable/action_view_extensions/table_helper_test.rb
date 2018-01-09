# frozen_string_literal: true

require 'test_helper'
require 'action_view'
require 'datatable'
require 'datatable/action_view_extensions/table_helper'

class FooDatatable
  include Datatable

  scope { Foo }

  column :name

  order_by :name, 'desc'
end

class TableHelperTest < ActionView::TestCase
  include Datatable::ActionViewExtensions::TableHelper

  test 'datatable_for adds default role to table' do
    concat datatable_for(FooDatatable)
    assert_select '#datatable'
  end
end
