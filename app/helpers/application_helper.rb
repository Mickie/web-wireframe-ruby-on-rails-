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
  
  def teamLogo(aTeam, aSize)
    theImageSize = "50x50"
    if (aSize == :medium)
      theImageSize = "80x80"
    elsif aSize == :large
      theImageSize = "110x110"
    end
    image_tag logoPath(aTeam.slug, aSize), { alt:aTeam.name, size:theImageSize }
  end
end
