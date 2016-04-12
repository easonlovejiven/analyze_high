# coding: utf-8
class Admin::SumMessagesController < Admin::BaseController

  def index
    
  end

  def more_sum_message
    @search = params[:search][:value] ? params[:search][:value] : ""
    @per_page = params[:per_page] ? params[:per_page] : 10
    page = params[:page] || 1
    start = params[:start].to_i || 0
    length = params[:length] ? params[:length].to_i : 10
    page = (start / length) + 1;
    @per_page = length;
    sum_messages = SumMessage.where([]).paginate(page: page , per_page: @per_page).order("id DESC")
    data = sum_messages.collect { |item| {:id => item.id, :post_id => item.post_id, :impression_count => item.impression_count, :click_count => item.click_count, :comment_count => item.comment_count, :praise_count => item.praise_count, :qq_share_count => item.qq_share_count, :wechat_share_count => item.wechat_share_count, :weibo_share_count => item.weibo_share_count, :genre => item.show_genre} }
    has_more = (sum_messages.length == 0 ? false : true)
    all_count = sum_messages.count
    draw = params[:draw].to_i + 1
    render :json => {:draw => draw, :has_more => has_more, :start => start, :recordsTotal => all_count, :recordsFiltered => all_count, :data => data }
  end   

  def show
    time = Time.now
    @sum_message = SumMessage.find(params[:id])
    @time_type = params[:time_type].to_i || 1#1小时，2天

    if @time_type == 1#小时
      @start_time = params[:start_time] || (time - 24*60*60)
      @end_time = params[:end_time] || time
      @messages = HourMessage.where(["post_id = ? and operation_time >= ? and operation_time <= ?", @sum_message.post_id, @start_time, @end_time]).order("operation_time ASC")
    else#天
      @start_time = params[:start_time] || (time - 7*24*60*60)
      @end_time = params[:end_time] || time
      @messages = DayMessage.where(["post_id = ? and operation_time >= ? and operation_time <= ?", @sum_message.post_id, @start_time, @end_time]).order("operation_time ASC")
    end
  end


  private

  def sum_message_params
    params.require(:sum_message).permit(:post_id, :impression_count, :click_count, :comment_count, :praise_count, :qq_share, :wechat_share, :weibo_share, :genre)
  end
end