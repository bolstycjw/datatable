# frozen_string_literal: true

require 'rails/generators/base'

module Datatable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def copy_assets
        source_root File.expand_path('../../vendor/assets', __dir__)
        copy_file 'datatable.js', 'app/assets/javascripts/datatable.js'
      end
    end
  end
end
