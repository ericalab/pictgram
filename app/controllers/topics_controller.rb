class TopicsController < ApplicationController
  # before_action :login_check, only: [:new, :edit, :update, :destroy]
  
  
  def index
    @topics = Topic.all.includes(:favorite_users)
  end
  
  def new
    @topic = Topic.new
  end
  
  def create
    @topic = @current_user.topics.new(topic_params)
    
    if @topic.save
      redirect_to topics_path, success: '投稿に成功しました'
    else
      flash.now[:danger] = "投稿に失敗しました"
      render :new
    end
  end

  def show
    @topic =Topic.find_by(id: params[:id])
    @user = @topic.user
    @comment = Comment.new
    
    respond_to do |format|
      format.html {

          
          @topic.comments.each do |comment|
            comment.content = compile_lines(comment)
          end
      
          @comments = @topic.comments
      
          lastCommentId = 0
          
          if @topic.comments.count > 0
            lastCommentId = @topic.comments.last.id;
          end
          
          render :show
      }

      # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
      format.json {
        newcomments = Comment.where('id > ? AND topic_id = ?', params[:comment][:id], params[:comment][:topic_id])
        newcomments.each do |comment|
          comment.content = compile_lines(comment)
        end
        @new_comment = newcomments
      }
    end
  end 
  
  private
  def topic_params
    params.require(:topic).permit(:image, :description)
  end
  
  def compile_lines(comment)
    lines = comment.user.name + '： ' + comment.content
    # Admin 又は ログインユーザのコメントには削除リンクを追加
    if current_user.id == comment.user_id
        lines += '<a href="/comments/delete?'
        lines += 'id=' + comment.id.to_s
        #lines += '&' + getLstScrTopParamName + '=' + @lstScrTop.to_s
        #lines += '&' + getScrTopParamName + '=' + @scrtop.to_s
        lines += '&' + 'topic_id' + '=' + @topic_id.to_s
        lines += '"><span style="color:#ff0000;">　×</span></a>'
    end
    return lines
  end
  
end
