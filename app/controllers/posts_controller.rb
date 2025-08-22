class PostsController < ApplicationController
  before_action :set_resource
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = policy_scope @resource.posts
  end

  def show
  end

  def new
    @post = Post.new

    authorize @post
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.resource = @resource
    @post.author = Current.user

    authorize @post

    if @post.save
      respond_to do |format|
        format.turbo_stream

        format.html { redirect_to @resource, notice: "Post was successfully created." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "posts_form",
            partial: "posts/form",
            locals: { resource: @resource, post: @post }
          )
        end

        format.html { redirect_back fallback_location: @resource, status: :unprocessable_content, alert: "Something went wrong" }
      end
    end
  end

  def update
    if @post.update(post_params)
      redirect_to [@resource, @post], notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy!

    redirect_to [@resource, Post], notice: "Post was successfully destroyed.", status: :see_other
  end

  private

  def set_resource
    if username = params[:user_username]
      @resource = User.find_by!(username: username)
    else
      render_not_found!
    end
  end

  def set_post
    @post = Post.where(resource: @resource).find(params.expect(:id))
    authorize @post
  end

  def post_params
    params.expect(post: [:body])
  end
end
