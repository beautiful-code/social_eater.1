# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
     process :resize_to_fill => [640, 320]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
