# frozen_string_literal: true

class Site < ApplicationRecord
  include SoftDelete

  belongs_to :site_node
  belongs_to :user

  validates :url, :name, :site_node_id, presence: true
  validates :url, format: { with: /https?:\/\/[\S]+/ }, uniqueness: { case_sensitive: false }

  mount_uploader :avatar, AvatarUploader
  after_commit :remove_avatar!, on: :destroy

  define_method :avatar? do
    self[:avatar].present?
  end

  after_save :update_cache_version
  after_destroy :update_cache_version
  def update_cache_version
    # 记录节点变更时间，用于清除缓存
    CacheVersion.sites_updated_at = Time.now.to_i
  end

  def favicon_url
    self.avatar.url.to_s
  rescue
    ""
  end
end
