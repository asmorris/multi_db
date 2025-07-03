# frozen_string_literal: true

class Badge::Component < ApplicationViewComponent
  option :variant, default: -> { :default }
  option :size, default: -> { :default }
  option :icon, optional: true
  option :html_attributes, default: -> { {} }

  private

  def badge_classes
    base_classes = "inline-flex items-center font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"

    # Skip variant background colors if custom bg classes are provided
    custom_classes = html_attributes[:class].to_s
    has_custom_bg = custom_classes.match?(/bg-\w+/)

    variant_classes = if has_custom_bg
      # Only apply non-background variant styles when custom bg is used
      case variant
      when :outline
        "border border-slate-200"
      else
        ""
      end
    else
      case variant
      when :secondary
        "bg-slate-100 text-slate-900 hover:bg-slate-100/80"
      when :destructive
        "bg-red-500 text-white hover:bg-red-500/80"
      when :outline
        "text-slate-950 border border-slate-200 bg-white hover:bg-slate-100"
      else # default
        "bg-slate-900 text-slate-50 hover:bg-slate-900/80"
      end
    end

    size_classes = case size
    when :sm
      "text-xs px-2.5 py-0.5 rounded-md"
    when :lg
      "text-sm px-3 py-1 rounded-lg"
    else # default
      "text-xs px-2.5 py-0.5 rounded-full"
    end

    [ base_classes, variant_classes, size_classes, html_attributes[:class] ].compact.reject(&:empty?).join(" ")
  end

  def icon_size_class
    case size
    when :sm
      "w-3 h-3"
    when :lg
      "w-4 h-4"
    else # default
      "w-3 h-3"
    end
  end

  def has_icon?
    icon.present?
  end

  def render_icon
    return unless has_icon?

    icon_class = [ icon_size_class, (content? ? "mr-1" : "") ].compact.reject(&:empty?).join(" ")
    begin
      helpers.icon(icon, class: icon_class)
    rescue => e
      # Fallback: render a simple checkmark if icon fails
      content_tag(:span, "✓", class: icon_class) if icon == "check-circle"
    end
  end
end
