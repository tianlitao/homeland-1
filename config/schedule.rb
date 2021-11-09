# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
RAILS_ROOT = File.dirname(__FILE__) + '/..'
set :output, "#{RAILS_ROOT}/log/whenever.log"

# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


# every 1.minutes do
#   rake "binance:snatch_article"
# end

# every 30.minutes do
#   rake "bihu:snatch_article"
# end

every 2.minutes do
  rake "discord:get_das_acount"
end

every 1.minutes do
  rake "discord:post_twitter"
end