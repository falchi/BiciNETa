class PointsController < ApplicationController

  before_filter :check_login, only: [:new,:edit]

  def check_login
    unless signed_in?
      flash[:error] = "Para editar o ingresar un nuevo punto debes estar logueado!"
      redirect_to root_path
    end
  end

  def index
    if params[:search].present?
      @points = Point.where("place like ?", "%" + params[:search].to_s + "%")
    else
      @points = Point.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @points }
    end
  end

  def testing
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @points }
    end
  end

  def show
    @point = Point.find(params[:id])
    @user = @point.user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @point }
    end
  end

  def new
    @user = User.find(current_user.id)
    @point = Point.new
    
    unless params[:search].nil?
      coord = Geocoder.coordinates(params[:search])
      @point.latitude = coord[0]#params[:point][:latitude]
      @point.longitude = coord[1]
    else
      @point.latitude = -33.457781
      @point.longitude = -70.590267
    end
  end

  def create
    @point = Point.new(params[:point])
    params[:point][:user_id] = current_user.id
    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, success: "El punto "+ @point.place + " ha sido creado correctamente :) " }
        format.json { render json: @point, status: :created, location: @point }
      else
        format.html { render action: "new" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @point = Point.find(params[:id])

    unless params[:search].nil?
      coord = Geocoder.coordinates(params[:search])
      @point.latitude = coord[0]#params[:point][:latitude]
      @point.longitude = coord[1]
    end
    
    unless current_user && ( @point.user && (@point.user.id == current_user.id)  || current_user.is_admin?)     
      respond_to do |format|
        flash[:error] = "No puedes editar un punto creado por otro usuario."
        format.html { redirect_to @point }
      end
    end  
  end

  def update
    @point = Point.find(params[:id])
    respond_to do |format|
      if @point.update_attributes(params[:point])
        format.html { redirect_to @point, success: 'El punto ' + @point.place + ' fue actualizado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @point = Point.find(params[:id])
    @point.destroy

    respond_to do |format|
      format.html { redirect_to points_path, notice: "El punto " + @point.place + " ha sido eliminado." }
      format.json { head :no_content }
    end
  end

end
