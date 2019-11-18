class CommentsController < ApplicationController
  
  
  def create
    comment = Comment.new
    comment.comment = params[:comment][:comment]
    comment.user_id = current_user.id
    comment.topic_id = params[:comment][:topic_id]
    
    if comment.save
      redirect_to topic_path(id: comment.topic_id), success: 'コメントを追加しました'
    else
      redirect_to topic_path(id: comment.topic_id), danger: 'コメントの追加に失敗しました'
    end
  end
  
  def destroy
    @comment = Comment.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    @ccommeny.destroy
    redirect_to("/topics/")
  end
  
end
