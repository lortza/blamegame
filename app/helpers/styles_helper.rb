# frozen_string_literal: true

module StylesHelper
  def table_classes
    'table is-striped is-narrow is-hoverable is-fullwidth'
  end

  def bootstrap_flash_class(type)
    case type
    when 'alert' then 'warning'
    when 'error' then 'danger'
    when 'warning' then 'warning'
    when 'notice' then 'success'
    else
      'info'
    end
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
end
