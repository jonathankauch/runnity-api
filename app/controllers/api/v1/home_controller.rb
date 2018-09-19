class Api::V1::HomeController < Api::V1::ApiController
  respond_to :json

  # before_action :current_user, except: [:create]
  before_action :authenticate_user!, :current_user

  def index
    @posts = Post.all.order(created_at: :desc)
    tmp_posts = []
    @posts.each do |post|
      tmp_comments = []
      tmp_post = post.attributes
      post.comments.each do |comment|
        tmp_comment = comment.attributes
        tmp_comment["user_fullname"] = comment.user.fullname
        tmp_comments << tmp_comment
      end
      tmp_post["comments"] = tmp_comments
      tmp_post["user"] = {
        user_id: post.user.id,
        full_name: post.user.fullname
      }
      tmp_posts << tmp_post
    end

    json_posts = tmp_posts.as_json
    json_posts.each_with_index do |post, i|
      if !@posts[i].pictures.first.nil?
        post['picture'] = @posts[i].pictures.first.url
      else
        post['picture'] = @posts[i].picture
      end
      post['likes'] = @posts[i].votes_for.size
      post['is_liked'] = current_user.voted_for?(@posts[i])
    end
    render :json => { posts: json_posts, status: :ok }
  end
end