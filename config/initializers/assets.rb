# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( jquery.qtip.css )
Rails.application.config.assets.precompile += %w( sentences.css )
Rails.application.config.assets.precompile += %w( words.css )

Rails.application.config.assets.precompile += %w( words.js )
Rails.application.config.assets.precompile += %w( sentences.js )
Rails.application.config.assets.precompile += %w( learned_words.js )
Rails.application.config.assets.precompile += %w( jquery-2.1.3.js )
Rails.application.config.assets.precompile += %w( jquery.qtip.js )

