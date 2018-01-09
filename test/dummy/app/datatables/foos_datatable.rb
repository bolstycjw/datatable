# frozen_string_literal: true

class FoosDatatable
  include Datatable

  scope { Foo }

  column :name

  order_by :name, 'desc'
end
