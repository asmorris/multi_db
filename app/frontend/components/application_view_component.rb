# frozen_string_literal: true

class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer

  private
  def class_names(*classes)
    classes.compact.select { |c| c.respond_to?(:empty?) && !c.empty? }.join(" ")
  end
end
