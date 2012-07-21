# encoding: utf-8
class UsersController < ApplicationController

  before_filter :check_login, :only => [:edit]

  def check_admin
    unless current_user && current_user.is_admin?
      flash[:info] = "Para "
    end    
  end

  def check_login
    unless signed_in?
      flash[:info] = "Debes loguearte para realizar esta operación"
      redirect_to root_path
    end
  end

  # GET /users
  # GET /users.json
  def index
    if params[:search].present?
      @users = User.where("name like ?", "%" + params[:search].to_s + "%")
    else
      @users = User.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @points = @user.points

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit     
    @user = User.find(params[:id])    
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to root_path, success: 'Bienvenido '+@user.name+'! :)' }
        format.json { render json: @user, status: :created, location: @user }
      else        
        flash[:error] = "Vuelve a llenar el formulario de registro, ocurrieron errores!"
        format.html { render "sessions/welcome" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete("password")
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, success: 'Se actualizaron los datos del usuario correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      flash[:info] = "El usuario " + @user.name + " ha sido eliminado." 
      format.html { redirect_to url_for(action: :index) }
      format.json { head :no_content }
    end
  end
end
