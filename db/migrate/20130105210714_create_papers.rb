class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :title
      t.string :source
      t.string :link
      t.text :abstract
      t.datetime :published_at

      t.timestamps
    end
  end
end
