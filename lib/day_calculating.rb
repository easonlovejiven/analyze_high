# coding: utf-8
class DayCalculating

  def calculating#修正day统计和总统计
  	if Vmstat.snapshot.load_average.one_minute < Vmstat.snapshot.cpus.count * 0.7



  	end
  end

end

DayCalculating.new.calculating