# frozen_string_literal: true

json.extract! post_type, :id, :name, :description_template, :created_at, :updated_at
json.url post_type_url(post_type, format: :json)
