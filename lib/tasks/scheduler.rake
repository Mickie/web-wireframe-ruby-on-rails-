desc "This task is called by the Heroku scheduler add-on"
task :send_followers_update => :environment do
    puts "Sending fanzone followers their daily update..."
    SocialSender.delay.sendFollowersTheirUpdates
    puts "done."
end

