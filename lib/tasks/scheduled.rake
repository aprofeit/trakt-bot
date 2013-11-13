namespace :bot do
  task :queue_downloads => :environment do
    bot = Bot.new
    bot.queue_downloads
  end
end
