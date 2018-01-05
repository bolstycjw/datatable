# frozen_string_literal: true

class FooDecorator < Draper::Decorator
  delegate_all

  def name
    "decorated #{object.name}"
  end
end
