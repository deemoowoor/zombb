class AddPostReferenceToPostComment < ActiveRecord::Migration
  def change
      change_table :post_comments do |t|
          t.references :post, index: true
      end
  end
end
