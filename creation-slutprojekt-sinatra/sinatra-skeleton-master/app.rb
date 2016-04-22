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
      session[:parent_id] = parent.id
    end
    redirect '/'
  end

  get '/sign_up' do

    erb :sign_up
  end

  post '/sign_up/create' do
    if params[:parent_account]
      Parent.create(username: params[:username], password: params[:password], email_address: params[:email], details: params[:details])
    else
      User.create(username: params[:username], password: params[:password], email_address: params[:email], details: params[:details])
    end
  redirect '/'

  end

  post '/log_out' do
    session.destroy
    redirect '/'
  end

  get '/activities' do
    if session[:user_id]
      @user = User.get(session[:user_id])
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
    end
    @event = true
    erb :activity
  end

  get '/new_activity' do
    if session[:user_id]
      @subjects = Subject.all(user_id: session[:user_id])
      @plans = Plan.all(user_id: session[:user_id])
    # elsif session[:parent_id]
      # @subjects = Subject.all(parent_id: session[:parent_id])
      # @plans = Plan.all(parent_id: session[:parent_id])
    else
      ArgumentError
    end
    erb :new_activity
  end

  post '/create_activity' do
    if session[:user_id]
      parent = false
    else
      parent = true
    end
    if params[:hidden_activity] == "hidden"
      hidden = true
    else
      hidden = false
    end
    Activity.create(title: params[:title], type: params[:type], subject: params[:subject], date: params[:due_date], planning: params[:planning], hidden: hidden, parent: parent)
    redirect '/activities'
  end


end