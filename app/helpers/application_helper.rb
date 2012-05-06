module ApplicationHelper
  def staticAssetBasePath
    Rails.application.config.static_asset_base_path
  end
  
  def logosPath
    staticAssetBasePath + "logos/"  
  end
  
  def logoPath(aSlug, aSize)
    theSuffix = "_s.gif"
    if aSize == :medium
      theSuffix = "_m.gif"
    elsif aSize == :large
      theSuffix = "_l.gif"
    end
    
    return logosPath + aSlug + theSuffix
  end
end
