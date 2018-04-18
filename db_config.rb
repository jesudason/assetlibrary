options = {
	adapter: 'postgres',
	database: 'dbname'
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)