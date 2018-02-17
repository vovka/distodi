class AccountUploader < PictureUploader
  version :icon do
    process resize_to_fill: [30, 30] # retains ratio, crops center
  end
end
