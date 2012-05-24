class SessionsController < ApplicationController
  def new

  end  		

  def create
    user = User.find_by_email(params[:session][:email]) #busca según el email ingresado
    if user && user.log_in(params[:session][:password]) #si existe y coincide la pass => retorna el user
      sign_in user 
      redirect_to root_path
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
