# frozen_string_literal: true

class Card::Component < ApplicationViewComponent
  option :title, optional: true
  option :subtitle, optional: true
  option :footer, optional: true
  option :variant, default: -> { :default }
  option :html_attributes, default: -> { {} }

  private

  def card_classes
    base_classes = "rounded-lg border bg-white shadow-sm"
    
    variant_classes = case variant
    when :elevated
      "shadow-md"
    when :outlined
      "border-2 border-gray-200"
    when :ghost
      "border-transparent shadow-none"
    else
      "border-gray-200"
    end

    [base_classes, variant_classes, html_attributes[:class]].compact.reject(&:empty?).join(" ")
  end

  def header_classes
    "flex flex-col space-y-1.5 p-6"
  end

  def title_classes
    "text-lg font-semibold leading-none tracking-tight"
  end

  def subtitle_classes
    "text-sm text-gray-600"
  end

  def content_classes
    "p-6 pt-0"
  end

  def footer_classes
    "flex items-center p-6 pt-0"
  end
end