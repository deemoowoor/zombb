class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.string :text
      t.datetime :timestamp

      t.timestamps
    end
  end
end
