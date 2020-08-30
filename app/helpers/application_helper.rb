# frozen_string_literal: true

module ApplicationHelper
  def page_title
    if content_for?(:title)
      content_for(:title)
    else
      'BlameGame'
    end
  end

  def session_links
    if current_user
      link_to 'Sign Out',
              destroy_user_session_path,
              method: :delete,
              class: 'button is-light'
    else
      link_to 'Sign In',
              user_session_path,
              class: 'button is-primary'
    end
  end
end
