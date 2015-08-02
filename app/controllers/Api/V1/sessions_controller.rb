class Api::V1::SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create, :destroy]

  def create
    @params = sessions_params

    if user = User.find_by(auth_token: @params[:token])
      if user.update_attributes(expiration_token: Date.now.to_date + 2.days, session_active: true)
        render json: {message: "Login success!", status: "success", user: user}
      else
        render json: {message: "Login failed", status: "error", err_msg: "Error to create session"}
      end
    else
      render json: {message: "Login failed", status: "error", err_msg: "Not user with #{@params[:token]}"}
    end
  end

  def destroy
    if @user.update_attributes(session_active: false, expiration_token: Date.new.to_date - 1.hour)
      render json: {message: "Logout success", statatus: "success"}
    else
      render json: {message: "Logout failed", statatus: "error", err_message: "Problems to close session"}
    end
  end

  private
    def sessions_params
      params.permit(:token)
    end
end
