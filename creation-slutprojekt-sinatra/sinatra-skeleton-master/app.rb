class App < Sinatra::Base
  enable :sessions

  get '/' do
  	"Hello, Sinatra!"

    erb :homepage
  end


end