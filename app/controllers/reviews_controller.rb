class ReviewsController < ApplicationController
  before_action :has_moviegoer_and_movie, :only => [:new, :create]
  before_action :authorized_reviewer, :only => [:edit, :update]
  
  protected
  
  def has_moviegoer_and_movie
    unless @current_user
      flash[:warning] = 'You must be logged in to create a review.'
      redirect_to '/auth/twitter'
    end
    unless (@movie = Movie.find(params[:movie_id]))
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to movies_path
    end
  end
  def authorized_reviewer
    unless (@movie = Movie.find(params[:movie_id]))
      flash[:warning] = 'Review must be for existing movie.'
      redirect_to movies_path
    end
    moviegoer_id = Review.find(params[:id]).moviegoer_id
    unless (@current_user = Moviegoer.find(moviegoer_id))
      flash[:warning] = 'You must be the reviewer to edit this review.'
      redirect_to movie_path(@movie)
    end
  end
  
  public
  
  def new
    @review = @movie.reviews.build
  end
  def create
    @current_user.reviews << @movie.reviews.build(review_params)
    redirect_to movie_path(@movie)
  end
  def edit
    @review = Review.find params[:id]
  end
  def update
    @review = Review.find params[:id]
    if params[:commit].eql?('Cancel')
      redirect_to movie_path(@movie)
    else
      if @review.update_attributes(review_params)
        flash[:notice] = "Your review was successfully updated."
        redirect_to movie_path(@movie)
      else
        render 'edit'
      end
    end
  end
  
  private
  
  def review_params
    params.require(:review).permit(:potatoes)
  end
  
end