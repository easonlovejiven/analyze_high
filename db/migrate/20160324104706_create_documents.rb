class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_updated_at
      t.integer  :status, default: 1#计算状态（1未计算，2计算完，3计算中）
      t.boolean  :state , default: true# 信息状态

      t.timestamps null: false
    end
  end
end
