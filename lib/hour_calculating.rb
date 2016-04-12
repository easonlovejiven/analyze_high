# coding: utf-8
require 'csv'
class HourCalculating

  def calculating
    if Vmstat.snapshot.load_average.one_minute < Vmstat.snapshot.cpus.count * 0.7
      document_ids = $redis.lrange("documents", 0, -1)#批量取出当前队列中的文件id
      $redis.del("documents")#清除当前队列内容
      hour = {}
      day = {}
      sum = {}

      documents = Document.all
      #documents = Document.where(["id in (?)", document_ids])
      documents.each do |document|
        filepath = File.join(Rails.root.to_s , "public", document.file.to_s.split("?")[0])
        #获取文件内容
        CSV.foreach(filepath) do |elements|
          post_id = elements[0] ? elements[0] : 0
          tmp_date = (elements[1] and elements[1].split(":")[0]) ? elements[1].split(":")[0] : "2000.1.1"
          tmp_hour = (elements[1] and elements[1].split(":")[1]) ? elements[1].split(":")[1] : "0"
          impression_count = elements[2] ? elements[2].to_i : 0
          click_count = elements[3] ? elements[3].to_i : 0

          #小时数据计算
          hour[post_id] = {} unless hour[post_id]
          hour[post_id][tmp_date] = {} unless hour[post_id][tmp_date]
          hour[post_id][tmp_date][tmp_hour] = {} unless hour[post_id][tmp_date][tmp_hour]

          if hour[post_id][tmp_date][tmp_hour]["impression_count"]
            hour[post_id][tmp_date][tmp_hour]["impression_count"] += impression_count
          else
            hour[post_id][tmp_date][tmp_hour]["impression_count"] = impression_count
          end

          if hour[post_id][tmp_date][tmp_hour]["click_count"]
            hour[post_id][tmp_date][tmp_hour]["click_count"] += click_count
          else
            hour[post_id][tmp_date][tmp_hour]["click_count"] = click_count
          end

          #天数据计算
          day[post_id] = {} unless day[post_id]
          day[post_id][tmp_date] = {} unless day[post_id][tmp_date]

          if day[post_id][tmp_date]["impression_count"]
            day[post_id][tmp_date]["impression_count"] += impression_count
          else
            day[post_id][tmp_date]["impression_count"] = impression_count
          end

          if day[post_id][tmp_date]["click_count"]
            day[post_id][tmp_date]["click_count"] += click_count
          else
            day[post_id][tmp_date]["click_count"] = click_count
          end

          #总数据计算
          sum[post_id] = {} unless sum[post_id]

          if sum[post_id]["impression_count"]
            sum[post_id]["impression_count"] += impression_count
          else
            sum[post_id]["impression_count"] = impression_count
          end

          if sum[post_id]["click_count"]
            sum[post_id]["click_count"] += click_count
          else
            sum[post_id]["click_count"] = click_count
          end

       end
      end


      HourMessage.transaction do#批量更新hour_message表
        hour.keys.each do |post|
          hour[post].keys.each do |tmp_date|
            hour[post][tmp_date].keys.each do |tmp_hour|
              hour_message = HourMessage.where(["post_id = ? and operation_time = ?", post, tmp_date+" "+tmp_hour]).first
              if hour_message
                hour_message.update_attributes!(:impression_count => hour_message.impression_count+hour[post][tmp_date][tmp_hour]["impression_count"], :click_count => hour_message.click_count+hour[post][tmp_date][tmp_hour]["click_count"])
              else
                HourMessage.create!(:post_id => post, :operation_time => tmp_date+" "+tmp_hour, :impression_count => hour[post][tmp_date][tmp_hour]["impression_count"], :click_count => hour[post][tmp_date][tmp_hour]["click_count"])
              end
            end
          end
        end
      end


      DayMessage.transaction do#批量更新day_message表
        day.keys.each do |post|
          day[post].keys.each do |tmp_date|
            day_message = DayMessage.where(["post_id = ? and operation_time = ?", post, tmp_date]).first
              if day_message
                day_message.update_attributes!(:impression_count => day_message.impression_count+day[post][tmp_date]["impression_count"], :click_count => day_message.click_count+day[post][tmp_date]["click_count"])
              else
                DayMessage.create!(:post_id => post, :operation_time => tmp_date, :impression_count => day[post][tmp_date]["impression_count"], :click_count => day[post][tmp_date]["click_count"])
              end
          end
        end
      end


      SumMessage.transaction do#批量更新sum_message表
        sum.keys.each do |post|
          sum_message = SumMessage.where(["post_id = ?", post]).first
          if sum_message
            sum_message.update_attributes!(:impression_count => sum_message.impression_count+sum[post]["impression_count"], :click_count => sum_message.click_count+sum[post]["click_count"])
          else
            SumMessage.create!(:post_id => post, :impression_count => sum[post]["impression_count"], :click_count => sum[post]["click_count"])
          end
        end
      end
      


      Document.transaction do#批量修改document表的状态
        documents.each do |document|
          document.update_attributes!(:status => 2)
        end
      end

    end
  end

end

HourCalculating.new.calculating