# frozen_string_literal: true

module Datatable
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Core
  autoload :Paginating

  included do
    include ::Datatable::Core
    include ::Datatable::Paginating
  end
end
