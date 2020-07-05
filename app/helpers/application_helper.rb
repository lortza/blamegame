# frozen_string_literal: true

require 'coderay'

module ApplicationHelper
  def page_title
    if content_for?(:title)
      content_for(:title)
    else
      'BlameGame'
    end
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

  def session_links
    if current_user
      link_to 'Sign Out',
              destroy_user_session_path,
              method: :delete,
              class: 'nav-link'
    else
      link_to 'Sign In',
              user_session_path,
              class: 'nav-link'
    end
  end

  def button_class(style = 'primary')
    "btn btn-sm btn-outline-#{style}"
  end

  def button_block(style = 'primary')
    "btn btn-outline-#{style} btn-block"
  end

  class CodeRayify < Redcarpet::Render::HTML
    CODERAY_OPTIONS = {
      filter_html: true,
      hard_wrap: true,
      safe_links_only: true,
      with_toc_data: true,
      prettify: true
    }.freeze

    REDCARPET_OPTIONS = {
      autolink: true,
      disable_indented_code_blocks: false,
      fenced_code_blocks: true,
      highlight: true,
      lax_html_blocks: true,
      lax_spacing: true,
      no_intra_emphasis: true,
      strikethrough: true,
      superscript: true,
      tables: true
    }.freeze

    def block_code(code, language)
      language = 'bash' if language.nil?
      CodeRay.scan(code, language).div(line_numbers: :table)
    end
  end

  # rubocop:disable Rails/OutputSafety
  def markdown(text)
    coderayified = CodeRayify.new(CodeRayify::CODERAY_OPTIONS)
    markdown_to_html = Redcarpet::Markdown.new(coderayified, CodeRayify::REDCARPET_OPTIONS)
    markdown_to_html.render(text).html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
