class App < Sinatra::Base
  enable :sessions

  get '/' do
    if session[:user_id]
      @user = User.get(session[:user_id])
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
    end
    erb :homepage
  end

  get '/login' do

    erb :login
  end

  post '/login/in' do
    if /.*[@].*/.match(params[:username_email])
      user = User.first(email_address: params[:username_email])
    elsif /[^\w]/.match(params[:username_email])
      ArgumentError
    else
      user = User.first(username: params[:username_email])
    end
    if /.*[@].*/.match(params[:username_email])
      parent = Parent.first(email_address: params[:username_email])
    elsif /[^\w]/.match(params[:username_email])
      ArgumentError
    else
      parent = Parent.first(username: params[:username_email])
    end
    if user && user.password == params[:password]
      session[:user_id] = user.id
    elsif parent && parent.password == params[:password]
      session[:password_id] = parent.id
    end
    redirect back
  end

  get '/sign_up' do

    erb :sign_up
  end

  post '/sign_up/create' do
    account =

  end

  post '/logout' do
    session.destroy
    redirect '/'
  end



end