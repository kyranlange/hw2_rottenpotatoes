class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    @ratings = params[:ratings] ? params[:ratings].keys : []
    
    redirect = false
    
    if @sort == nil and session[:sort]
      redirect = true
    else 
      session[:sort] = @sort
    end
    
    if @ratings.length == 0 and session[:ratings]
      redirect = true
    else 
      session[:ratings] = params[:ratings]
    end
    
    if redirect
      redirect_to movies_path({:sort => session[:sort], :ratings => session[:ratings]})
    end
    
    if @sort == 'title'
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.empty? ? @all_ratings : @ratings }, :order => "title ASC")
    elsif @sort == 'release_date'
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.empty? ? @all_ratings : @ratings}, :order => "release_date ASC")
    else 
      @movies = Movie.find(:all, :conditions => {:rating => @ratings.empty? ? @all_ratings : @ratings})
    end 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
