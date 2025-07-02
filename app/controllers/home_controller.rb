# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]
  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    datastar = Datastar.new(request:, response:, view_context:)

    datastar.stream do |sse|
      if @post.save
        card_html = Card::Component.new(
          title:    @post.name,
          subtitle: @post.description
        )
        sse.merge_fragments card_html, selector: "#garby", merge_mode: :append
        sse.merge_fragments '<div id="question">What do you put in a toaster?</div>'
      else
        sse.merge_signals error: "Failed to save post"
      end
    end
  end

  def test
    datastar = Datastar.new(request:, response:, view_context:)

    datastar.stream do |sse|
      # Merges fragment into the DOM
      sse.merge_fragments %(<div id="question">What do you put in a toaster?</div>)

      # Merges signals
      # sse.merge_signals(response: "", answer: "bread")
    end
  end

  private

  def post_params
    params.expect(post: [ :name, :description ])
  end
end
