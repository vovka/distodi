class AccountUploader < PictureUploader
  version :icon do
    process resize_to_fill: [30, 30] # retains ratio, crops center
  end

  version :at_profile_page do
    process resize_to_fill: [302, 255]
  end
end
