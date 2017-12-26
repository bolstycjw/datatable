# frozen_string_literal: true

require 'datatable/action_view_extensions/table_helper'

module Datatable
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Core
  autoload :Searching
  autoload :Ordering
  autoload :Paginating
  autoload :TableHelper

  included do
    include ::Datatable::Core
    include ::Datatable::Searching
    include ::Datatable::Ordering
    include ::Datatable::Paginating
  end
end
