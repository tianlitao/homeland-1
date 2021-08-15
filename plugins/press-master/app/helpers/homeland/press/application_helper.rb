module Homeland::Press
  module ApplicationHelper
    delegate :comments_path, to: :main_app

    def press_user_name_tag(post)
      return post.post_info.author if post.post_info&.author
      return '官方' if post.user.admin?
      user_name_tag(post.user)
    end
  end
end
