class SitemapSweeper < ActionController::Caching::Sweeper
  observe Tailgate

  def sweep( aTailgate )
    expire_page(sitemap_path)
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end