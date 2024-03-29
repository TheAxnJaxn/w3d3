class CreateShortenedUrLs < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :long_url, null: false
      t.string :shortened_url, unique: true
      t.integer :submitter_id, null: false
      t.timestamps
    end

    add_index :shortened_urls, :submitter_id
    add_index :shortened_urls, :shortened_url
  end
end
