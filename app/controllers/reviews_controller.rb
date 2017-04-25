class ReviewsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  def new
    @movie = Movie.find(params[:movie_id])
    @review = Review.new
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = Review.new(review_params)
    @review.movie = @movie
    @review.user = current_user

    if @review.save
      redirect_to movie_path(@movie)
    else
    render  :new
  end

end


  def edit
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
    @review.movie = @movie
    @review.user = current_user
  end

  def show
  end

  def update
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
    @review.movie = @movie
    @review.user = current_user
    if
      @review.update(review_params)
      redirect_to movie_path(params[:movie_id]), notice:"修改评论成功！"
    else
      render edit
    end

  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.find(params[:id])
    @review.movie = @movie
    @review.user = current_user
    @review.destroy
     flash[:alert]= "已删除评论！"
    redirect_to movie_path(@movie)
  end



private

def review_params
params.require(:review).permit(:content,  )
end


end
