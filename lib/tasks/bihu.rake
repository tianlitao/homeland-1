# frozen_string_literal: true
namespace :bihu do

  task snatch_article: :environment do
    print "get bihu topic"
    Task.all.each do |task|
      task.bihu
    end
  end
end

