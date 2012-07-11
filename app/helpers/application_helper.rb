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
    if aTeam.slug
      theImageSize = "50x50"
      if (aSize == :medium)
        theImageSize = "80x80"
      elsif aSize == :large
        theImageSize = "110x110"
      end
      return image_tag logoPath(aTeam.slug, aSize), { alt:aTeam.name, size:theImageSize }
    end
  end
  
  def getBitlyForUrl(aUrl)
    Bitly.use_api_version_3
    theClient = Bitly.new("paulingalls", "R_3448e4644415daf490d94e5ef0174509")
    theBitly = nil
    
    begin
      theUrlResult = theClient.shorten(aUrl)
      theBitly = theUrlResult.short_url
    rescue Exception => e
      Rails.logger.warn "Error getting Bitly: #{e.to_s}"
      return nil
    end
    
    return theBitly
  end  
  
  def handleNewlinesAndUrls( aString )
    aString.gsub(/\n/, "<br/>").gsub(/\(?\bhttp:\/\/[-A-Za-z0-9+&@#\/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#\/%=~_()|]/i) { |a| 
      "<a href='#{a}' target='_blank'>#{a}</a>"
    }
  end
end
