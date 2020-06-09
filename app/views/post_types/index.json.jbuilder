# frozen_string_literal: true

json.array! @post_types, partial: 'post_types/post_type', as: :post_type
