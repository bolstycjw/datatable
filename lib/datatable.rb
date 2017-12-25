# frozen_string_literal: true

module Datatable
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Core
  autoload :Searching
  autoload :Ordering
  autoload :Paginating

  included do
    include ::Datatable::Core
    include ::Datatable::Searching
    include ::Datatable::Ordering
    include ::Datatable::Paginating
  end
end
