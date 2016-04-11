class CreateHourMessages < ActiveRecord::Migration
  def change
    create_table :hour_messages do |t|
      t.integer :post_id
      t.integer :impression_count, default: 0
      t.integer :click_count, default: 0
      t.integer :comment_count, default: 0
      t.integer :praise_count, default: 0
      t.integer :qq_share_count, default: 0
      t.integer :wechat_share_count, default: 0
      t.integer :weibo_share_count, default: 0
      t.integer :genre
      t.string :day_mark
      t.string :hour_mark

      t.timestamps null: false
    end

    add_index :hour_messages, :post_id
    add_index :hour_messages, :day_mark
    add_index :hour_messages, :hour_mark
  end
end
