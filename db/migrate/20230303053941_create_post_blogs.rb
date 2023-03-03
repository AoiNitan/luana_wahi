class CreatePostBlogs < ActiveRecord::Migration[6.1]
  def change
    create_table :post_blogs do |t|
      t.string :title_blog
      t.text :content_blog
      t.integer :user_id

      t.timestamps
    end
  end
end
