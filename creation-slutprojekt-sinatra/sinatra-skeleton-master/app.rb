require 'pry'
class App < Sinatra::Base
  enable :sessions

  # before do
  #   @user = User.get(session[:user])
  # end

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
      Parent.create(username: params[:username], password: params[:password],
                    email_address: params[:email], details: params[:details])
    else
      User.create(username: params[:username], password: params[:password],
                  email_address: params[:email], details: params[:details],
                  bed_time: Time.new(0000,01,01,20,00))
    end
  redirect '/'

  end

  post '/log_out' do
    session.destroy
    redirect '/'
  end

  get '/activities/simple' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @activity = []
      sort = []
      for activity in Activity.all(user_id: session[:user_id])
        sort << {:date => activity.date, :id => activity.id}
      end
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @activity = []
      sort = []
      for child in @parent.users
        for activity in Activity.all(user_id: child.id)
          sort << {:date => activity.date, :id => activity.id}
        end
      end
    else
      redirect '/'
    end
    sort.sort_by! do |item|
      item[:date]
    end
    for item in sort
      @activity << Activity.get(item[:id])
    end
    @event = true
    @simple = true
    erb :activity
  end

  get '/activities/calendar/?' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @activity = []
      sort = []
      for activity in Activity.all(user_id: session[:user_id])
        sort << {:date => activity.date, :id => activity.id}
      end
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @activity = []
      sort = []
      for child in @parent.users
        for activity in Activity.all(user_id: child.id)
          sort << {:date => activity.date, :id => activity.id}
        end
      end
    else
      redirect '/'
    end
    sort.sort_by! do |item|
      item[:date]
    end
    for item in sort
      @activity << Activity.get(item[:id])
    end
    @date = Date.new(Date.today.year,Date.today.next_month.month,1)
    @event = true
    @simple = false
    erb :activity
  end

  get '/new_activity/?' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @subjects = Subject.all(user_id: session[:user_id])
      @plans = Plan.all(user_id: session[:user_id])
    else
      redirect '/'
    end
    erb :new_activity
  end

  # For Parent
  get '/new_activity/:id/?' do |child_id|
    if session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @subjects = Subject.all(user_id: child_id)
      @plans = Plan.all(user_id: child_id)
      @child = User.first(id: child_id).username
    else
      redirect '/'
    end
    erb :new_activity
  end

  post '/create_activity' do
    if session[:user_id]
      parent = false
      if params[:hidden_activity] == "hidden"
        hidden = true
      else
        hidden = false
      end

      activity = Activity.create(title: params[:title], type: params[:type], subject: params[:subject],
                      date: "#{params[:due_date]} #{params[:time]}", planning: params[:planning],
                      time: params[:length].to_i, hidden: hidden, parent: parent, user_id: session[:user_id])
      if params[:planning] != "nil"
        activity.plan(plan_length: Plan.first(name: params[:planning], user_id: session[:user_id]).length)
      end
      redirect '/activities/simple'
    else
      parent = true
      user = User.first(username: params[:child]).id
      date = DateTime.strptime("#{params[:due_date]}T#{params[:time]}", '%Y-%m-%dT%H:%M')
      activity = Activity.create(title: params[:title], type: params[:type], subject: params[:subject],
                      time: params[:length].to_i, date: date, planning: params[:planning],
                      hidden: false, parent: parent, user_id: user )
      if params[:planning] != "nil"
        activity.plan(plan_length: Plan.first(name: params[:planning], user_id: user).length)
      end
    end
    redirect '/'
  end

  post '/activity/delete/?' do
    Activity.get(params[:id].to_i).destroy
    redirect back
  end

  get '/management' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @search = Parent.get(session[:search])
      @relative = @user.parents
      requests = ParentRequest.all(user_id: session[:user_id])
      @requesters = []
      for request in requests
        @requesters << Parent.get(request.requester_id)
      end
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @search = User.get(session[:search])
      @relative = @parent.users
      requests = UserRequest.all(parent_id: session[:parent_id])
      @requesters = []
      for request in requests
        @requesters << User.get(request.requester_id)
      end
      p "hej"
      p @requesters
    end
    erb :parent_management
  end

  post '/parent_validation' do
    search = Parent.first(username: params[:name])
    unless search == nil
      session[:search] = search.id
    end
    redirect back
  end

  post '/child_validation' do
    search = User.first(username: params[:name])
    unless search == nil
      session[:search] = search.id
    end
    redirect back
  end

  post '/user_request/?' do
    user = User.get(session[:user_id])
    parent = Parent.get(session[:search])
    unless user.parents.include? parent then UserRequest.create(time: Time.now, requester_id: session[:user_id], parent_id: session[:search]) end
    redirect back
  end

  post '/parent_request/?' do
    parent = Parent.get(session[:parent_id])
    user = User.get(session[:search])
    unless parent.users.include? user then ParentRequest.create(time: Time.now, requester_id: session[:parent_id], user_id: session[:search]) end
    redirect back
  end

  post '/remove_relative/:id/?' do |relative_id|
    if session[:user_id] != nil
      relation = ParentUser.get(relative_id, session[:user_id])
    else
      relation = ParentUser.get(session[:parent_id], relative_id)
    end
    relation.destroy
    redirect back
  end

  post '/confirmation/:id/?' do |request_id|
    if params[:option] == "Accept" && session[:parent_id]
      user = User.get(request_id)
      parent = Parent.get(session[:parent_id])
      parent.users << user
      parent.save
      request = UserRequest.first(:requester_id => request_id)
      request.destroy
    elsif params[:option] == "Decline" && session[:parent_id]
      request = UserRequest.first(:requester_id => request_id)
      request.destroy
    elsif params[:option] == "Accept" && session[:user_id]
      parent = Parent.get(request_id)
      user = User.get(session[:user_id])
      user.parents << parent
      user.save
      request = ParentRequest.first(:requester_id => request_id)
      request.destroy
    elsif params[:option] == "Decline" && session[:user_id]
      request = ParentRequest.first(:requester_id => request_id)
      request.destroy
    end
    redirect back
  end

  get '/profile' do
    if session[:user_id]
      @user = User.get(session[:user_id])
      @subjects = Subject.all(user_id: session[:user_id])
      @plans = Plan.all(user_id: session[:user_id])
    elsif session[:parent_id]
      @parent = Parent.get(session[:parent_id])
      @children = @parent.users
      @subjects = []
      @plans = []
      for child in @children
        @subjects << Subject.all(user_id: child.id)
        @plans << Plan.all(user_id: child.id)
      end
    else
      redirect '/'
    end
    erb :profile
  end

  post '/new_subject' do
    if session[:user_id]
      user = session[:user_id]
    elsif session[:parent_id]
      user = User.first(username: params[:child])
    else
      redirect '/'
    end
    Subject.create(name: params[:subject], user_id: user)
    redirect back
  end

  post '/delete_subject' do
    if session[:user_id]
      subject = Subject.first(user_id: session[:user_id], name: params[:subject])
      subject.destroy
    end
    redirect back
  end

  post '/new_plan' do
    if session[:user_id]
      user = session[:user_id]
    elsif session[:parent_id]
      user = User.first(username: params[:child])
    else
      redirect '/'
    end
    Plan.create(name: params[:title], length: params[:length].to_i, amount: params[:amount].to_i, weekend: params[:weekend].to_i, user_id: user)
    redirect back
  end

  post '/delete_plan' do
    if session[:user_id]
      plan = Plan.first(user_id: session[:user_id], name: params[:name])
      plan.destroy
    end
    redirect back
  end

  post '/update_details' do
    if session[:parent_id]
      person = Parent.get(session[:parent_id])
    elsif session[:user_id]
      person = User.get(session[:user_id])
    else
      redirect '/'
    end
    person.update(:details => params[:details])
    redirect back
  end

  post '/update_bed_time' do
    if session[:user_id]
      User.get(session[:user_id]).update(:bed_time => params[:time])
      redirect back
    end
    redirect '/'
  end
end