# frozen_string_literal: true

class PostTypesController < ApplicationController
  before_action :set_post_type, only: %i[show edit update destroy]

  def index
    @post_types = current_user.post_types.all
  end

  def show
    search_terms = params[:search]
    given_year = params[:given_year]

    @posts = @post_type.posts
                       .search(given_year: given_year, search_terms: search_terms)
                       .by_date
                       .paginate(page: params[:page], per_page: 50)
  end

  def new
    @post_type = current_user.post_types.new
  end

  def edit
  end

  def create
    @post_type = current_user.post_types.new(post_type_params)

    if @post_type.save
      redirect_to @post_type
    else
      render :new
    end
  end

  def update
    if @post_type.update(post_type_params)
      redirect_to post_types_url
    else
      render :edit
    end
  end

  def destroy
    @post_type.destroy
    redirect_to post_types_url, notice: "Post type #{@post_type.name} was destroyed."
  end

  private

  def set_post_type
    @post_type = current_user.post_types.find(params[:id])
  end

  def post_type_params
    params.require(:post_type).permit(:name, :description_template)
  end
end
