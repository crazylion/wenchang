class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook # You need to implement the method below in your model @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user) 
     @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
#        logger.debug "user.persised"
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        sign_in_and_redirect @user, :event => :authentication
    else
      logger.debug "user.nopersised"
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
