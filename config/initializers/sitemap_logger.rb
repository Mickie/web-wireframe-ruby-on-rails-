if Rails.env.development?
  log_path = File.join(Rails.root, 'log/sitemap.log')
  log_file = File.open(log_path, 'a')
  log_file.sync = true
else
  log_file = STDOUT    
end

SitemapLogger = Logger.new(log_file)