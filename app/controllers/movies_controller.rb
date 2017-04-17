class MoviesController < ApplicationController
  before_action :authenticate_user! ,only: [:new, :create, :edite, :update, :destroy, :collect, :cancel]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page =>5)
  end

  def edit

  end

  def new
    @movie = Movie.new
end

def create
  @movie = Movie.new(movie_params)
  @movie.user = current_user

  if @movie.save
  current_user.collect!(@movie)
  redirect_to movies_path
else
  render :new
end
end

def update


if   @movie.update(movie_params)

  redirect_to movies_path, notice: "更新成功"
else
  render :edit
end
end

def destroy

  @movie.destroy
  flash[:alert] = "电影已删除"
  redirect_to movies_path
end

def collect
  @movie = Movie.find(params[:id])

  if !current_user.is_collect_of?(@movie)
    current_user.collect!(@movie)
    flash[:notice] = "收藏成功!"
  else
    flash[:warning] = "你已经收藏该影片"
  end

  redirect_to movie_path(@movie)
end

def cancel
  @movie = Movie.find(parames[:id])

  if current_user.is_collect_of?(movie)
    current_user.cancel!(@movie)
    flash[:notice] = "已取消收藏"
  else
    flash[:warning] = "你还未收藏该影片"
  end

  redirect_to movie_path(@movie)
end

private

def find_movie_and_check_permission
  @movie = Movie.find(params[:id])

  if current_user != @movie.user
    redirect_to root_path, alert: "你没有权限进行此操作"
  end
end

def movie_params
  params.require(:movie).permit(:title, :description)
end

end
