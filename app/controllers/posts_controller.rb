class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :create_comment, :like_post]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @like = current_user.likes.find_by(post_id: @post.id).nil?
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def create_comment
    unless user_signed_in?
      respond_to do |format|
        format.js { render 'please_login.js.erb' }
      end
    end
    @c = @post.comments.create(body: params[:body]) #현재 post id함께 거기에 comments 함께 작성
  end


  def like_post
    unless user_signed_in?
      respond_to do |format|
        format.js { render 'please_login.js.erb' }
      end
    else
      if Like.where(user_id: current_user.id, post_id: @post.id).first.nil?
        #@post를 쓰기 위해선 set post를 해야한다. before action에 추가한다.
        #좋아요를 누르지 않은 상태에 대한 실행문
        @result = current_user.likes.create(post_id: @post.id)
        puts "좋아요누름"
      else
        #좋아요를 누른 상태에 대한 실행문
        #좋아요를 삭제하면 됨
        @result = current_user.likes.find_by(post_id: @post.id).destroy
        puts "좋아요 취소"
      end
      @result = @result.frozen?
      #ORM을 통해 가지고온 객체는 DB Row
      #Like.create => DB ROW ++;
      #Like.destroy => DB ROW --;
      #@post.destroy
      #사라지지않고 freeze 됨. 메모리에는 존재하지만 DB에는 존재하지않는존재가된다.
      # freeze => frozen? true 이면 좋아요 취소한 경우이다.
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :contents)
    end
end