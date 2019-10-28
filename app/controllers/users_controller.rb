class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(name: params[:user][:name], email: params[:user][:email])
    if @user.save
      redirect_to root_path, success: '登録が完了しました'
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new
    end
  end
end

