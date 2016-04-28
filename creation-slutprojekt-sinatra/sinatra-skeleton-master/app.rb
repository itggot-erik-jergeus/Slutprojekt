class App < Sinatra::Base
  enable :sessions

  # before do
  #   @user = User.get(session[:user])
  # end

  get '/' do
    if session[:user]
      @user = session[:user]
    elsif session[:parent]
      @parent = session[:parent]
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
      session[:user] = user
    elsif parent && parent.password == params[:password]
      session[:parent] = parent
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

  get '/activities/simple' do
    if session[:user]
      @user = session[:user]
      @activity = Activity.all(user_id: session[:user].id)
    elsif session[:parent]
      @parent = session[:parent]
    end
    @event = true
    @simple = true
    erb :activity
  end

  get '/activities/calendar' do
    if session[:user]
      @user = session[:user]
      @activity = Activity.all(user_id: session[:user].id)
    elsif session[:parent]
      @parent = Parent.get(session[:parent].id)
    end
    @event = true
    @simple = true
    erb :activity
  end

  get '/new_activity' do
    if session[:user]
      @user = session[:user]
      @subjects = Subject.all(user_id: session[:user].id)
      @plans = Plan.all(user_id: session[:user].id)
    # elsif session[:parent]
      # @parent = session[:parent]
      # @subjects = Subject.all(parent_id: session[:parent].id)
      # @plans = Plan.all(parent_id: session[:parent].id)
    else
      ArgumentError
    end
    erb :new_activity
  end

  post '/create_activity' do
    if params[:hidden_activity] == "hidden"
      hidden = true
    else
      hidden = false
    end
    if session[:user]
      parent = false
      Activity.create(title: params[:title], type: params[:type], subject: params[:subject],
                      date: params[:due_date], planning: params[:planning],
                      hidden: hidden, parent: parent, user_id: session[:user].id )
    else
      parent = true
      # Activity.create(title: params[:title], type: params[:type], subject: params[:subject],
      #                 date: params[:due_date], planning: params[:planning],
      #                 hidden: hidden, parent: parent, user_id: session[:parent_id] )
    end
    redirect '/activities/simple'
  end

  get '/parent_management' do
    if session[:user]
      @user = session[:user]
      @parent_search = session[:parent_search]
    elsif session[:parent]
      @parent = session[:parent]
    end
    erb :parent_management
  end

  post '/parent_validation' do
    session[:parent_search] = Parent.first(username: params[:name])

    redirect back
  end

  post '/user_request' do
    UserRequest.create(time: Time.now, user_username: session[:user])

    redirect back
  end

  post '/parent_request' do
    ParentRequest.create(time: Time.now, parent_username: session[:user])

    redirect back
  end
end