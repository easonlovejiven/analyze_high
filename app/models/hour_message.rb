# coding: utf-8
class HourMessage < ActiveRecord::Base

  validates_presence_of :post_id, :operation_time
  validates_uniqueness_of :post_id, scope: [:operation_time]

  def show_genre
    {1 => "type1", 2 => "type2", 3 => "type3"}[self.genre]
  end
  
end
