# frozen_string_literal: true

class FoosDatatable
  include Datatable

  scope { Foo }

  filter(:id, :name) do |scope, id, name|
    scope.where(id: id).where('name LIKE ?', "%#{name}%")
  end

  column :name
  column :created_at

  action 'Rename to Bar', :namechange_foos_path, 'Bar', class: 'btn btn-primary'

  order_by :name, 'desc'
end
