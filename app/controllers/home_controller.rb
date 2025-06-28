# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to root_path, notice: "post was successfully created."
    else
      @posts = Post.all
      render :index, status: :unprocessable_entity
    end
  end

  def test
    datastar = Datastar.new(request:, response:, view_context:)

    datastar.stream do |sse|
      # Merges fragment into the DOM
      sse.merge_fragments %(<div id="question">What do you put in a toaster?</div>)

      # Merges signals
      sse.merge_signals(response: "", answer: "bread")
    end
  end

  private

  def post_params
    params.require(:post).permit(:name, :description)
  end
end
