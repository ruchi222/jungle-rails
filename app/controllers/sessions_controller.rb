class SessionsController < ApplicationController
    def new
  
    end
  
    def create
      puts params[:email].inspect
      user = User.find_by_email(params[:sessions][:email])
      if user && user.authenticate(params[:sessions][:password])
        session[:user_id] = user.id
        redirect_to '/'
      else
      # If user's login doesn't work, send them back to the login form.
        redirect_to '/login'
      end
    end
  
    def destroy
      session[:user_id] = nil
      redirect_to '/login'
    end
  end