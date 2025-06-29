# frozen_string_literal: true

class DarkModeToggle::Component < ApplicationViewComponent
  option :classes, optional: true

  private

  def button_class
    @button_class ||= class_names(
      classes.presence,
      "relative inline-flex h-8 w-14 items-center rounded-full transition-all duration-200 ease-in-out focus:outline-none focus:ring-2 ring-ring focus:ring-offset-2 focus:ring-offset-background shadow-inner border border-border"
    )
  end

  def knob_class
    "absolute top-1 left-1 h-6 w-6 rounded-full shadow-md transition-all duration-200 ease-in-out flex items-center justify-center"
  end
end
