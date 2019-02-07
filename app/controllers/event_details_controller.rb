class EventDetailsController < ApplicationController
  def index
    @event_details = EventDetail.where(event_id: params[:event_id], id: current_user.event_detail_ids).order("testtime_id ASC, id ASC")
  end

  def edit
    if current_user.event_detail_ids.include? params[:id].to_i
      @event_detail = EventDetail.find_by event_id: params[:event_id], id: params[:id]
    else
      flash[:error] = "噢不！您沒有權限執行這個操作，請洽系統管理員"
      redirect_to event_event_details_path(params[:event_id])
    end
  end

  def update

    if current_user.event_detail_ids.include? params[:id].to_i
      @event_detail = EventDetail.find_by event_id: params[:event_id], id: params[:id]
      if @event_detail.update_attributes! event_detail_params
        flash[:notice] = "考場資訊更新成功"
      else
        flash[:error] = "噢不！更新失敗了，請洽系統管理員"
      end
      redirect_to event_event_details_path(params[:event_id])
    else
      flash[:error] = "噢不！您沒有權限執行這個操作，請洽系統管理員"
      redirect_to event_event_details_path(params[:event_id])
    end
  end

  def event_detail_params
    params.require(:event_detail).permit(:actual, :retake, :violate, :note)
  end
end
