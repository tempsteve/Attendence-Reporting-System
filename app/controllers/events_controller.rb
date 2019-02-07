class EventsController < ApplicationController
  def index
    @events = Event.order("event_date ASC").all
  end

  def show
    if current_user.is_admin?
      @event = Event.find params[:id]
    else
      flash[:error] = "噢不！您沒有權限執行這個操作，請洽系統管理員"
      redirect_to events_path
    end
  end
end
