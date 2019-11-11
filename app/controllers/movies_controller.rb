class MoviesController < ApplicationController
  def index
    @movies = Movie.order(:title)
    #@movies = Movie.all.sort { |a,b| a.title <=> b.title }
  end
  def show
    begin
      id = params[:id]
      @movie = Movie.find(id)
    rescue
      flash[:notice] = "Sorry. The requested movie doesn't exist yet."
      redirect_to movies_path
    end
  end
  def new
    @movie = Movie.new
  end
  def create
    if params[:commit].eql?('Cancel')
      redirect_to movies_path
    else
      @movie = Movie.new(movie_params)
      if @movie.save
        flash[:notice] = "#{@movie.title} was successfully created."
        redirect_to movie_path(@movie)
      else
        render 'new'
      end
    end
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    if params[:commit].eql?('Cancel')
      redirect_to movie_path(@movie)
    else
      if @movie.update_attributes(movie_params)
        flash[:notice] = "#{@movie.title} was successfully updated."
        redirect_to movie_path(@movie)
      else
        render 'edit'
      end
    end
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie #{@movie.title} deleted."
    redirect_to movies_path
  end
  
  private
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :release_date, :description)
  end
end