class CreatePostBlogComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_blog_comments do |t|
      t.text :blog_comment
      t.integer :user_id
      t.integer :post_blog_id

      t.timestamps
    end
  end
end
