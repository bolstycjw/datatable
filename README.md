# Datatable
This is a ruby/rails wrapper around a popular jquery library Datatables.js. It allows you to use the jquery Datatables library server-side without writing a single line of javascript code. All datatables configuration is done through a simple DSL by including the Datatable module into your class.

Current supported features:
* Server-side sorting
* Server-side filtering
* Draper decorator

Heavily inspired by [bogdan/datagrid](https://github.com/bogdan/datagrid/tree/master/lib/datagrid).

## Usage

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
  
  # Optional: decorates the collection if you are using Draper::Decorator
  decorate

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
``` ruby
# app/views/users/index.html.erb

<%= datatable_for(UsersDatatable, url: users_path(format: :json)) %>
```

### Scope

Default scope of objects to filter and display.

``` ruby
scope do
  User.includes(:group)
end
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

```
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
