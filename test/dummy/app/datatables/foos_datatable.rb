# frozen_string_literal: true

class FoosDatatable
  include Datatable

  scope { Foo }

  filter(:id, :name) do |scope, id, name|
    scope.where(id: id).where('name LIKE ?', "%#{name}%")
  end

  column :name
  column :created_at

  action 'Mark for GIRO', :mark_for_giro_foos_path

  order_by :name, 'desc'
end
