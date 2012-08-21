class SitemapPinger 
  SEARCH_ENGINES = {
    google: { base_url: "http://www.google.com", path:"/webmasters/tools/ping", param:"sitemap" },
    ask: { base_url: "http://submissions.ask.com", path:"/ping", param:"sitemap" },
    bing: { base_url: "http://www.bing.com", path:"/webmasters/ping.aspx", param:"siteMap" }
  }

  def self.ping
    SitemapLogger.info Time.now
    SEARCH_ENGINES.each do |name, aUrlMap|
      SitemapLogger.info "  Pinging #{name}"

      if Rails.env == "production"
        theConnection = Faraday.new( aUrlMap[:base_url] )
        
        theResponse = theConnection.get aUrlMap[:path] do | aRequest |
          aRequest.params[ aUrlMap[:param] ] = "http://#{ENV['FANZO_WEB_HOST']}/sitemap.xml"
        end
        SitemapLogger.info "    Status: #{theResponse.status}"
        SitemapLogger.info "    Body: #{theResponse.body}"
      end
    end
  end
end