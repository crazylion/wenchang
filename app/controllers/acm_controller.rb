class AcmController < ApplicationController
  def fetch
    @email =  ""
    @email = current_user.email  if user_signed_in?
  end

  def mail
    
  end
end
