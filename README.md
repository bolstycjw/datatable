# Datatable
This is a ruby/rails wrapper around a popular jquery library Datatables.js. It allows you to use the jquery Datatables library without writing a single line of javascript code. All datatables configuration is done through a simple DSL by including the Datatable module into your class.

Heavily inspired by [bogdan/datagrid](https://github.com/bogdan/datagrid/tree/master/lib/datagrid).

## Usage

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

## Contributing
[Pull requests](https://github.com/brolycjw/datatable/pulls) are very welcome! Please include tests for every patch, and create a topic branch for every separate change you make.

Report issues or feature requests to [GitHub Issues](https://github.com/brolycjw/datatable/issues).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
