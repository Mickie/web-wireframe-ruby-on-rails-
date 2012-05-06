module ApplicationHelper
  def staticAssetBasePath
    Rails.application.config.static_asset_base_path
  end
  
  def logosPath
    staticAssetBasePath + "logos/"  
  end
end
