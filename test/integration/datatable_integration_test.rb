# frozen_string_literal: true

require 'test_helper'

class DatatableIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
    create_list(:foo, 2)
  end

  test 'visiting the index' do
    visit '/foos'
    assert_selector 'table#datatable tr td', count: 2
  end
end
