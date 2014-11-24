class AddAssociationsToPosts < ActiveRecord::Migration
  def change
      add_column :posts, :user_id, :integer
      add_column :post_comments, :user_id, :integer
  end
end
