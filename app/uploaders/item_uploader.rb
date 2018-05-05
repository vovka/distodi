class ItemUploader < PictureUploader
  # Create different versions of your uploaded files:
  version :cover do
    # does not retain ratio
    process resize_to_limit: [448, 435]
  end

  version :mini do
    # retains ratio, exactly 100*75, adds white borders
    # process :resize_and_pad => [100, 75]
    process :resize_to_fill => [100, 75]
  end

  version :thumb do
    # retains ratio, crops center
    process :resize_to_fill => [50, 50]
  end

  version :additional_photo do
    process resize_to_limit: [95, 77]
  end

  version :list do
    process resize_to_fill: [250, 166]
  end

  version :at_service_page do
    process resize_to_fill: [312, 210]
  end
end
