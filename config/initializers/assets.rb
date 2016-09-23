# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w[
  *.png
  *.jpg
  *.jpeg
  *.gif
  administrator/index.js
  curator/index.js
  dean/index.js
  education_department/index.js
  group_leader/index.js
  lecturer/index.js
  public/index.js
  subdepartment/index.js
]
