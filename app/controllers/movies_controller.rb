class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #sorting from part 1
    @movies = Movie.order(params[:sort])
    
    @sort = params[:sort]
    if params.has_key?(:sort)
      @sort = params[:sort]
    elsif session.has_key?(:sort)
      @sort = session[:sort]
      redirect = true 
    end

    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
      redirect = false 
    
    @ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
    if params.has_key?(:ratings)
       @ratings = params[:ratings]
    elsif session.has_key?(:ratings)
       @ratings = session[:ratings]
       redirect = true
    end
    
    @movies = @movies.where(:rating => params[:ratings].keys) if params[:ratings].present?
    session[:ratings] = @ratings
    
    #keeps the rating values checked
    if redirect
      flash.keep
      redirect_to movies_path({:sort => @sort, :ratings => @ratings})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
