# coding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :face,
    styles: { medium: "180x180#", small: "80x80#" },
    default_url: "/img/missing_face.png",
    url: "/system/:class/:attachment/:id/:style/:id.:extension",
    whiny: false
    validates_attachment_content_type :face, content_type: /\Aimage\/.*\Z/

  def show_genre
    {1 => "超级管理员", 2 => "管理员", 3 => "普通用户"}[self.genre]
  end

end
