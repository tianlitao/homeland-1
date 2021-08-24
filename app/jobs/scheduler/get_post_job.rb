# frozen_string_literal: true

module Scheduler
  class GetPostJob < ApplicationJob
    def perform
      Taks.each do |task|
        task.bihu
      end
    end
  end
end
