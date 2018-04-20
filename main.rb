require 'sinatra'
require 'active_record'
require 'cloudinary'

require_relative 'db_config'
require_relative 'models/asset'
require_relative 'models/comment'
require_relative 'models/user'

if Sinatra::Application.settings.development? 
	require 'sinatra/reloader'
	require 'pry'
end

enable :sessions

helpers do
	def current_user
		User.find_by(id: session[:user_id])
	end

	def logged_in?
		!!current_user
	end
end

get '/' do
	@assets = Asset.all 
	erb :index
	# binding.pry
end

post '/' do
  asset = Asset.new
  asset.image = params[:image]
  asset.save
end

get '/register' do
	erb :register
end

post '/session' do
	user = User.find_by(email: params[:email])
	# binding.pry	
	if user && user.authenticate(params[:password])
		session[:user_id] = user.id
		redirect to("/profile/#{current_user.username}")
	else
		redirect to('/')
	end
end

delete '/session' do
	session[:user_id] = nil
	redirect to('/')
end

post '/profile' do
	@user = User.new
	@user.username = params['username']
	@user.email = params['email']
	@user.password = params['password']
	@user.name = params['real_name']
	@user.website = params['website']
	@user.about_me = params['about_me']
	@user.save
	session[:user_id] = @user.id
	redirect to("/profile/#{current_user.username}")
	
end

get '/profile/:username' do
	@user = User.find_by(username: params[:username])
	@assets = Asset.where(user_id: @user.id)
	erb :profile
end

post '/comments' do
	comment = Comment.new
	comment.content = params[:content]
	comment.asset_id = params[:asset_id]
	comment.user_id = current_user.id
	comment.save
	@comments = Comment.where(asset_id: params[:asset_id])
	redirect to("/asset/#{params[:asset_id]}")
end

get '/asset/new' do
	@user = current_user
	erb :new
end

post '/asset' do
	@asset = Asset.new
	@asset.name = params[:name]
	@asset.description = params[:description]
	@asset.image = params[:image]
	@asset.asset_file = params[:asset_file]
	@asset.user_id = current_user.id
	@asset.save
	redirect to("/asset/#{@asset.id}")
end	

get '/asset/:id' do
	@asset = Asset.find_by(id: params[:id] )
	@user = User.find_by(id: @asset.user_id)
	@comments = Comment.where(asset_id: @asset.id)
	# binding.pry
	erb :asset
end

delete '/asset' do
	Asset.find_by(id: params[:id] ).destroy
	redirect to("/profile/#{current_user.username}")
end

get '/chat' do
	erb :chat
end

get '/lost' do
	erb :lost
end