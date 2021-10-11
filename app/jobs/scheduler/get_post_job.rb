# frozen_string_literal: true

module Scheduler
  class GetPostJob < ApplicationJob
    def perform
      Task.all.each do |task|
        task.bihu
      end
    end
  end
end
