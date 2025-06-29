class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer

  private
  def class_names(*classes)
    classes.compact.reject(&:empty?).join(" ")
  end
end
