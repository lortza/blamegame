# frozen_string_literal: true

module StylesHelper
  # rubocop:disable Rails/OutputSafety

  def table_classes
    'table is-striped is-hoverable is-fullwidth'
  end

  def bulma_flash_class(type)
    modifier = case type
               when 'alert' then 'is-warning'
               when 'error' then 'is-danger'
               when 'warning' then 'is-warning'
               when 'notice' then 'is-success'
               else
                 'is-info'
               end

    "notification #{modifier}"
  end

  def button_classes(style = 'is-primary')
    "button is-outlined #{style}"
  end

  def button_block(style = 'is-primary')
    "button is-fullwidth #{style}"
  end

  def boolean_checkmark(value)
    '<i class="fas fa-check"></i>'.html_safe if value
  end

  def boolean_check_or_x(value)
    icon = value ? '<i class="fas fa-check"></i>' : '<i class="fas fa-times"></i>'
    icon.html_safe
  end

  # rubocop:enable Rails/OutputSafety
end
