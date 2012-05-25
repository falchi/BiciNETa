class PointsController < ApplicationController
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

  def show
    @point = Point.find(params[:id])
    @user = @point.user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @point }
    end
  end

  def new
    @point = Point.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @point }
    end

  end

  def create
    @point = Point.new(params[:point])
    params[:point][:user_id] = @current_user.id

    respond_to do |format|
      if @point.save
        format.html { redirect_to @point, notice: 'Point was successfully created.' }
        format.json { render json: @point, status: :created, location: @point }
      else
        format.html { render action: "new" }
        format.json { render json: @point.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @point = Point.find(params[:id])
  end

  def update
    @point = Point.find(params[:id])
    respond_to do |format|
      if @point.update_attributes(params[:point])
        format.html { redirect_to @point, notice: 'Point was successfully updated.' }
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
      format.html { redirect_to points_path }
      format.json { head :no_content }
    end
  end
end
