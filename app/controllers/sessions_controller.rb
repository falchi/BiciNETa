# encoding: utf-8
class SessionsController < ApplicationController



  def welcome
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new

  end

  def create
    user = User.find_by_email(params[:session][:email]) #busca según el email ingresado
    if user && user.log_in(params[:session][:password]) #si existe y coincide la pass => retorna el user
      sign_in user
      msg = (user.is_admin ? "[Eres Administrador]" : " :) ")
      flash[:success] = 'Bienvenido(a) ' + user.name + '! ' + msg
      redirect_to root_path     
    else
      flash.now[:error] = 'Hubo un error al intentar conectarse. Revisa tu mail y contraseña ingresados!'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
