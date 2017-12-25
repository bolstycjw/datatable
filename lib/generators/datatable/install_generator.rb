# frozen_string_literal: true

module Datatable
  module Generators
    class InstallGenerator < Rails::Generator::Base
      def copy_assets
        source_root File.expand_path('../../vendor/assets', __dir__)
        copy_file 'datatable.js', 'app/assets/javascripts/datatable.js'
      end
    end
  end
end
