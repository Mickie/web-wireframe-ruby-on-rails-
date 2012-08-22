class SitemapObserver < ActiveRecord::Observer
  observe Tailgate

  def ping(aTailgate)
    SitemapPinger.ping if Rails.env.production?
  end

  alias_method :after_create, :ping
  alias_method :after_update, :ping
  alias_method :after_destroy, :ping
end