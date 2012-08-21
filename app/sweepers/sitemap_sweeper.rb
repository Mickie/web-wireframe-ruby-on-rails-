class SitemapSweeper < ActionController::Caching::Sweeper
  observe Tailgate

  def sweep( aTailgate )
    expire_action(controller: "sitemap", action: :show )
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end