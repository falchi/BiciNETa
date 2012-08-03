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
    #raise env['omniauth.auth'].to_yaml #twitter hash
    #auth_hash = request.env['omniauth.auth'] #fb hash
    auth = request.env['omniauth.auth']

    if auth
      @authorization = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"]) 
      if @authorization
        sign_in @authorization.user
        msg = (@authorization.user.is_admin ? "[Eres Administrador]" : " :) ")
        flash[:success] = 'Te has logueado vía '+auth["provider"]+'. Bienvenido(a) ' + @authorization.user.name + '! ' + msg
        redirect_to root_path #render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
      else               
        #raise auth.to_yaml
        sign_in @authorization.user
        user = User.new :name => auth["info"]["name"], :email => auth["info"]["email"]
        user.authorizations.build :provider => auth["provider"], :uid => auth["uid"]
        if user.save(validate: false)
          flash[:success] = 'Te has logueado vía '+auth["provider"]+'. Bienvenido(a) ' + auth["info"]["name"] + '! '# + msg     
          redirect_to root_path #render :text => "Hi #{user.name}! You've signed up."
        else
          msg = "\n"+user.errors.to_yaml
          flash[:error] = 'No se pudo crear el usuario '+ auth["info"]["name"]+ ' para '+ auth["provider"]     +"......"+msg
          redirect_to root_path #render :text => "Hi #{user.name}! You've signed up."
        end
        
      end

    else #if normal signup
      raise "HELLO!"

    end

    
 
    #render :text => auth_hash.inspect

    
  end

  def destroy
    sign_out
    flash[:error] = "Se ha cerrado sesión exitosamente!"
    redirect_to root_path
  end
end
