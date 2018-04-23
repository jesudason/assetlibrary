
require 'carrierwave'
require 'carrierwave/orm/activerecord'

class ImageUploader < CarrierWave::Uploader::Base

	if Sinatra::Application.settings.development?
		include CarrierWave::MiniMagick
	else
		include Cloudinary::CarrierWave
	end
	# process resize_to_fit: [800, 800]
	version :thumb do
		process resize_to_fill: [250,250]
	end


	if Sinatra::Application.settings.development?
		storage :file
	end

end

class Asset < ActiveRecord::Base
  	mount_uploader :image, ImageUploader
  	mount_uploader :asset_file, ImageUploader
  	has_many :comments
	belongs_to :user
end
