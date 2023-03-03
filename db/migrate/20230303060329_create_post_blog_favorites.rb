class CreatePostBlogFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :post_blog_favorites do |t|
      t.integer :user_id
      t.integer :post_blog_id

      t.timestamps
    end
  end
end
