class TasklistsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  def create
    @tasklist=current_user.tasklists.build(tasklist_params)
    if @tasklist.save
      flash[:success]='タスクを登録しました'
      redirect_to root_url
    else
      @tasklists=current_user.tasklists.order('created_at DESC').page(params[:pages])
      flash.now[:danger]='タスクの投稿に失敗しました'
      render 'toppages/index'
    end
  end

  def destroy
    @tasklist.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def tasklist_params
    params.require(:tasklist).permit(:content)
  end
  
  def correct_user
    @tasklist = current_user.tasklists.find_by(id: params[:id])
    unless @tasklist
      redirect_to root_url
    end
  end
end
