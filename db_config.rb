options = {
	adapter: 'postgresql',
	database: 'assetlibrary'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
