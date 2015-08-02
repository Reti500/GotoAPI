class Api::V1::UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:index, :new, :create, :destroy, :add_social_relation]

  def index
    render json: {suers: User.all}
  end

  def create
    @params = user_params

    if @params[:sign_up_type].eql?("social")
      pass = SecureRandom.hex

      @user = User.new(email: @params[:email], password: pass, password_confirmation: pass,
        session_active: true)

      @user.social_relations << SocialRelation.create(name: @params[:social_name],
        access_token: @params[:access_token], social_id: @params[:social_id])

      if @user.save
        render json: {message: "User #{@user.email} created", status: "success", auth_token: @user.auth_token}
      else
        render json: {message: "Error to create user #{@user.email}", status: "error"}
      end
    else
      @user = User.new(user_params)

      if @user.save
        render json: {message: "User #{@user.email} created", status: "success", auth_token: @user.auth_token}
      else
        render json: {message: "Error to create user #{@user.email}", status: "error"}
      end
    end
  end

  def update
  end

  def destroy
  end

  def add_social_relation
    @user = User.find_by(auth_token: params[:token])

    unless params[:social_name] || params[:access_token]
      render json: {message: "Error en los parametros", status: "error"}
      return
    end

    unless @user
      render json: {message: "User error", status: "error"}
      return
    end

    if @social = @user.social_relations.find_by(name: params[:social_name])
      if @social.update_attributes(access_token: params[:access_token])
        render json: {message: "Updated access token", status: "success"}
      else
        render json: {message: "Error to updated access token #{params[:access_token]}"}
      end
    else
      if @user.social_relations << SocialRelation.create(
        name: params[:social_name], access_token: params[:access_token])
        render json: {message: "Create social relation", status: "success"}
      else
        render json: {message: "Error to create social relation #{params[:social_name]}"}
      end
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :sign_up_type,
      :social_name, :access_token, :social_id)
    end

end
