class FoosController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: FoosDatatable.new(view_context) }
    end
  end
end
