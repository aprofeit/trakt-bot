Setup
=====

1. Copy ```config/keys.sample.yml``` to ```config/keys.yml``` and populate with valid credentials.
2. Make sure you have all the shows you want auto downloaded added to your watchlist on trakt.tv
3. Run ```rake bot:queue_downloads``` on a repeating job. Suggested every 10 minutes.