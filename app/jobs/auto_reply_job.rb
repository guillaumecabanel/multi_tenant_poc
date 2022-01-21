class AutoReplyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Post.create(title: "reply", content: "hello to you too")
  end
end
