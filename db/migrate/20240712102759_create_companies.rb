# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.string :description
      t.string :yc_batch
      t.string :website
      t.string :founder_names
      t.string :linkedin_urls

      t.timestamps
    end
  end
end
