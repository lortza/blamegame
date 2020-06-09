# frozen_string_literal: true

module PostsHelper
  def timeframes_dropdown
    Report.available_years + Report.timeframe_labels
  end

  def display_categories(post)
    post.categories.map(&:name).join(', ')
  end
end
