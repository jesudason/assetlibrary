require 'carrierwave'
require 'carrierwave/orm/activerecord'

class ImageUploader < CarrierWave::Uploader::Base
	# include CarrierWave::MiniMagick
	include Cloudinary::CarrierWave
	# process resize_to_fit: [800, 800]
	version :thumb do
		process resize_to_fill: [500,500]
	end
	# storage :file

end

class Asset < ActiveRecord::Base
  	mount_uploader :image, ImageUploader
  	has_many :comments
	belongs_to :user
end
