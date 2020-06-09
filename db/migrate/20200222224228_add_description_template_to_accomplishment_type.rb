# frozen_string_literal: true

class AddDescriptionTemplateToAccomplishmentType < ActiveRecord::Migration[6.0]
  def change
    add_column :accomplishment_types, :description_template, :text
  end
end
