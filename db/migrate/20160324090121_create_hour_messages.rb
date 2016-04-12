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
      t.datetime :operation_time

      t.timestamps null: false
    end

    add_index :hour_messages, :post_id
    add_index :hour_messages, :operation_time
  end
end
