# frozen_string_literal: true

module Datatable
  extend ActiveSupport::Autoload
  extend ActiveSupport::Concern

  autoload :Core

  included do
    include ::Datatable::Core
  end
end
