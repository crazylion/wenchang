class AcmController < ApplicationController
  def fetch
    @email =  ""
    @email = current_user.email  if user_signed_in?
  end

  def mail
    p params[:page]
   Delayed::Job.enqueue(DelayedRake.new("download",:page=>params[:page])) 
   render :text=>"ok"
  end
end
