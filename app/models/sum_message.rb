# coding: utf-8
class SumMessage < ActiveRecord::Base

  validates_presence_of :post_id
  validates_uniqueness_of :post_id
  
  def show_genre
    {1 => "type1", 2 => "type2", 3 => "type3"}[self.genre]
  end

end
