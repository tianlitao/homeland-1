# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'homeland/press'

Homeland.register_plugin do |plugin|
  plugin.name              = 'press'
  plugin.display_name      = '首页'
  plugin.description       = '官方内容。'
  plugin.version           = Homeland::Press::VERSION
  plugin.navbar_link       = true
  plugin.admin_navbar_link = true
  plugin.root_path         = '/posts'
  plugin.admin_path        = '/admin/posts'
end
