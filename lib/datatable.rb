# frozen_string_literal: true

require 'datatable/action_view_extensions/table_helper'
require 'datatable/engine.rb'

module Datatable
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Core
  autoload :Filtering
  autoload :Searching
  autoload :Ordering
  autoload :Paginating
  autoload :TableHelper

  included do
    include ::Datatable::Core
    include ::Datatable::Filtering
    include ::Datatable::Searching
    include ::Datatable::Ordering
    include ::Datatable::Paginating
  end
end
