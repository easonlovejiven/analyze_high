# coding: utf-8
class Document < ActiveRecord::Base

  # 生成一层文件夹
  Paperclip.interpolates :day do |attachment, style|
    attachment.instance.created_at.strftime("%Y%m%d")
  end

  Paperclip.interpolates :hour do |attachment, style|
    attachment.instance.created_at.strftime("%H")
  end

  has_attached_file :file,
    default_url: "/file/missing_file.csv",
    url: "/system/:class/:attachment/:day/:hour/:id.:extension",
    whiny: false
    validates_attachment_content_type :file, content_type: /text/


  def show_status
    {1 => "未计算", 2 => "计算完", 3 => "文件错误"}[self.status]
  end

end
