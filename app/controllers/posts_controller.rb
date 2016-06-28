class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order('created_at DESC')
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    if session[:user_id] == nil
      redirect_to home_path, notice: 'You must log in to access this page.'
    end
  end

  # GET /posts/1/edit
  def edit
    unless @post.user == current_user
      redirect_to home_path, notice: "This post doesn't belong to you!"
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post = Post.create(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html { redirect_to user_post_path(session[:user_id], Post.last), notice: 'Post was successfully created.' }
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
    if @post.user_id != session[:user_id]
      format.html { render "root", notice: "This post doesn't belong to you!" }
    end

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to user_post_path(session[:user_id], Post.last), notice: 'Post was successfully updated.' }
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
    unless @post.user == current_user
      redirect_to home_path, notice: "This post doesn't belong to you!"
    else
      respond_to do |format|
        format.html { redirect_to user_posts_path(session[:user_id]), notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # def search
  #   search = Article.search params[:term]
  #   @articles = search.results
  #   render 'index' # or your view
  # end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :user_id, :media)
    end
end
