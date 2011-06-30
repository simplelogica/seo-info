class CreateSeoInfos < ActiveRecord::Migration
  def self.up
    create_table :seo_infos do |t|
      t.string :seoable_type
      t.integer :seoable_id
      t.string :url
      t.string :h1
      t.string :title
      t.text :description
      t.column :footer, :longtext

      t.timestamps
    end
  end

  def self.down
    drop_table :seo_infos
  end
end
