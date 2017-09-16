class CreateVideoCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :video_categories do |t|
      t.integer :category_id, :video_id
    end
  end
end
