require 'sinatra'
require 'active_record'
require_relative 'db_config'     

get '/' do
  erb :index
end

get '/register' do
	erb :register
end

get '/login' do
	erb :login
end

post '/session' do
	# check database for email
	user = User.find_by(email: params[:email])
	if user && user.authenticate(params[:password])
		session[:user_id] = user.id
		redirect to("/")
	else
		erb :login
	end
end

delete '/session' do
	session[:user_id] = nil
	redirect to('/login')
end

get '/profile' do
	@user = User.new
	@user.username = params['username']
	@user.email = params['email']
	@user.real_name = params['real_name']
	@user.website = params['website']
	@user.about_me = params['about_me']
	@user.save
end

post '/comments' do
	comment = Comment.new
	comment.content = params[:content]
	comment.dish_id = params[:asset_id]
	comment.user_id = current_user.id
	comment.save
	# redirect to("/assets/#{params[:dish_id]}")
end

post '/assets' do
	asset = Asset.new
	asset.name = params[:name]
	asset.description = params[:description]
	asset.image = params[:image]
	asset.save
	# redirect to("/dishes/#{params[:dish_id]}")
end	
