namespace :bot do
  task :queue_downloads do
    bot = Bot.new
    bot.queue_downloads
  end
end
