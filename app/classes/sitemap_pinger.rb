class SitemapPinger 
  SEARCH_ENGINES = {
    google: "http://www.google.com/webmasters/tools/ping?sitemap=%s",
    ask: "http://submissions.ask.com/ping?sitemap=%s",
    bing: "http://www.bing.com/webmaster/ping.aspx?siteMap=%s"
  }

  def self.ping
    SitemapLogger.info Time.now
    SEARCH_ENGINES.each do |name, url|
      theRequestUrl = url % CGI.escape("http://#{ENV['FANZO_WEB_HOST']}/sitemap.xml")  
      SitemapLogger.info "  Pinging #{name} with #{theRequestUrl}"
      if Rails.env == "production"
        theResponse = Faraday.get theRequestUrl
        SitemapLogger.info "    Status: #{theResponse.status}"
        SitemapLogger.info "    Body: #{theResponse.body}"
      end
    end
  end
end