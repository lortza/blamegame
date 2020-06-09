# frozen_string_literal: true

json.extract! post, :id, :description, :post_type_id, :url, :bookmarked, :created_at, :updated_at
json.url post_url(post, format: :json)
