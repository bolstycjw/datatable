# Datatable
This is a ruby/rails wrapper around a popular jquery library Datatables.js. It allows you to use the jquery Datatables library server-side without writing a single line of javascript code. All datatables configuration is done through a simple DSL by including the Datatable module into your class.

Current supported features:
* Server-side sorting
* Server-side filtering
* Draper decorator

Heavily inspired by [bogdan/datagrid](https://github.com/bogdan/datagrid/tree/master/lib/datagrid).

## Usage

add to gemfile
``` ruby
# Gemfile
$ gem 'datatable', github: 'brolycjw/datatable'
```

import datatables assets
```console
$ yarn add datatables.net
```

add to asset pipeline
``` ruby
# app/assets/javascripts/application.js
//= require jquery/dist/jquery
...
//= require datatables.net/js/jquery.dataTables
```

run generator to copy assets
```console
$ rails generate datatable:install
```

create a datatable:
``` ruby
# app/datatables/users_datatable.rb

class UsersDatatable
  include Datatable

  scope do
    User.includes(:group).references(:group)
  end
  
  # optional: decorates the collection with draper
  decorate
  
  # filter by name and created_at between start_date and end_date
  filter :name, start_date, end_date do |scope, name, start_date, end_date|
    scope.where('name LIKE ?', "%#{name}%").where(created_at: start_date..end_date)
  end

  column(:name)
  # with custom order and search
  column(:group, order: 'groups.name', search: 'groups.name') do |user|
    user.name
  end
  # with custom header
  column(:active, header: "Activated") do |user|
    !user.disabled
  end
  
  # default column to order by
  order_by :name, :desc

end
```

add json response to controller:
``` ruby
# app/controllers/users_controller.rb

class UsersController
  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end
  ...
end
```

render datatable with datatable view helper:
``` erb
<%# app/views/users/index.html.erb %>

<%= datatable_for(UsersDatatable) %>

<%# or with custom url %>
<%= datatable_for(UsersDatatable, url: users_path(format: :json)) %>
```

### Scope

Default scope of objects to filter and display.

``` ruby
scope do
  User.includes(:group)
end
```

### Filter

Additional filtering functionality for filtering beyond the basic fuzzy search

``` ruby
filter(:name) do |scope, name|
  scope.where('name LIKE ?', "%#{name}%")
end

filter(:start_date, :end_date) do |scope, start_date, end_date|
  scope.where(date: start_date..end_date)
end
```

``` erb
<%# app/views/users/index.html.erb %>

<%= form_tag(users_path, method: :get) do |f| %>
  <%= f.text_field :name %>
  <%= f.date_field :start_date %>
  <%= f.date_field :end_date %>
<% end %>

<%= datatable_for(UsersDatatable) %>
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'datatable'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install datatable
```

## Client-side Datatable customization
You may customize the datatable's client-side features by modifying the included datatable.js.

Example for Buttons extension:

``` js
# app/assets/javascripts/datatable.js

$(function () {
  $('#datatable').each(function () {
    var datatable = $(this).DataTable({
      lengthChange: false,
      responsive: true,
      processing: true,
      serverSide: true,
      ajax: { url: $(this).data('url') }
    })
    new $.fn.dataTable.Buttons(datatable, {
      buttons: ['colvis', 'excel', 'pdf']
    });
    datatable.buttons().container().appendTo('#datatable_wrapper .col-md-6:eq(0)')
  })
})
```


## Contributing
[Pull requests](https://github.com/brolycjw/datatable/pulls) are very welcome! Please include tests for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/brolycjw/datatable/issues).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
