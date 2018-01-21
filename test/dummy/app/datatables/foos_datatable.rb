# frozen_string_literal: true

class FoosDatatable
  include Datatable

  scope { Foo }

  filter(:id, :name) do |scope, id, name|
    scope.where(id: id).where('name LIKE ?', "%#{name}%")
  end

  column :name

  order_by :name, 'desc'
end
