module ApplicationHelper
  def staticAssetBasePath
    Rails.application.config.static_asset_base_path
  end
  
  def logosPath
    staticAssetBasePath + "logos/"  
  end
  
  def logoPath(aSlug, aSize)
    theSuffix = "_l.png"
    
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
      return image_tag logoPath(aTeam.slug, aSize), { alt:aTeam.name, size:theImageSize, class:"logoImage" }
    end
  end
  
  def getBitlyForUrl(aUrl)
    Bitly.use_api_version_3
    theClient = Bitly.new(ENV["FANZO_BITLY_USERNAME"], ENV["FANZO_BITLY_API_KEY"])
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
  
  def getTailgateBitly( aTailgate )
    if aTailgate.bitly && aTailgate.bitly.length > 0
      return aTailgate.bitly
    end

    theTailgateUrl = Rails.application.routes.url_helpers.tailgate_url(aTailgate, host: ENV["FANZO_WEB_HOST"])
    theBitly = getBitlyForUrl(theTailgateUrl)
    
    if (theBitly && theBitly.length > 0)
      aTailgate.bitly = theBitly
      aTailgate.save
      return aTailgate.bitly
    else
      return theTailgateUrl
    end
  end

  def getEventBitly( anEvent )
    if anEvent.bitly && anEvent.bitly.length > 0
      return anEvent.bitly
    end

    theEventUrl = Rails.application.routes.url_helpers.event_url(anEvent, host: ENV["FANZO_WEB_HOST"])
    theBitly = getBitlyForUrl(theEventUrl)
    
    if (theBitly && theBitly.length > 0)
      anEvent.bitly = theBitly
      anEvent.save
      return anEvent.bitly
    else
      return theEventUrl
    end
  end

  
  def getLargeLogoBitly( aTeam )
    if (aTeam.large_logo_bitly && aTeam.large_logo_bitly.length > 0)
      return aTeam.large_logo_bitly
    end
    
    theLogoPath = logoPath(aTeam.slug, :large)
    theBitly = getBitlyForUrl(theLogoPath)
    
    if (theBitly && theBitly.length > 0)
      aTeam.large_logo_bitly = theBitly
      aTeam.save
      return aTeam.large_logo_bitly
    else
      return theLogoPath
    end
  end
  
  
end
