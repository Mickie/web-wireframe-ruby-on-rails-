desc "This task is called by the Heroku scheduler add-on"
task :send_followers_update => :environment do
    puts "Sending fanzone followers their daily update..."
    SocialSender.delay.sendFollowersTheirUpdates
    puts "done."
end

task :update_bing_results => :environment do
    puts "Update teams with the latest Bing search results"
    BingSearcher.new.delay.updateBingSearchResults
    puts "done."
end

task :update_amazon_results => :environment do
    puts "Update teams with the latest Amazon search results"
    AmazonProductFinder.new.delay.updateAmazonProductResults
    puts "done."
end
