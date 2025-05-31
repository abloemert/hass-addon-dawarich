# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

module CustomAssetPath
  def compute_asset_path(path, options = {})
    ingress_path = request.headers['X-Ingress-Path']
    original_path = super
    "#{ingress_path}#{original_path}"
  end
end

# Patch into ActionView's asset path resolution
Sprockets::Rails::Helper.prepend(CustomAssetPath)

