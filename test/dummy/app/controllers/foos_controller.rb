class FoosController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: FoosDatatable.new(view_context) }
    end
  end

  def state
    Foo.where(id: params[:ids]).update(name: params[:state])
  end
end
