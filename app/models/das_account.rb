class DasAccount < ApplicationRecord
  has_many :das_list_sales

  before_create do
    self.depth = self.domain.gsub('.bit', '').strip.size
    if self.invite_domain.present?
      self.invite_id = DasAccount.find_by(domain: self.invite_domain)&.id
    end
  end


  HEADER = {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36',
      'authorization' => 'ODY3ODA0ODU1MjMwMDA1MzA4.YPmcVg.iRQmn4cB0o_T6CRsoI-fymQKER0'
  }

  def self.get_das_account
    last_id = DasAccount.last&.discord_id || 0
    born_url = "https://discord.com/api/v9/channels/831429673115451395/messages?limit=100&after=#{last_id}"
    data_json = JSON.parse(RestClient.get(born_url, headers=HEADER))
    data_json.each do |data|
      data['content'].split('\n').each do |content|
        das = DasAccount.find_or_initialize_by(domain: content[/(?<=\*\* ).*(?= \*\*)/])
        das.start_at = data['timestamp'].to_datetime
        das.year = content[/(?<=registed for ).*(?= year\(s\))/].to_i
        das.end_at = das.start_at + das.year&.year
        das.invite_domain = content[/(?<=invited by ).*$/]
        das.discord_id = data['id']
        das.save if das.changed?
      end
    end
  end

  def self.get_list_account
    last_id = DasListSale.where.not(list_time: nil).order('list_time desc').first&.list_discord_id || 0
    list_url = "https://discord.com/api/v9/channels/899487316115095562/messages?limit=100&after=#{last_id}"
    data_json = JSON.parse(RestClient.get(list_url, headers=HEADER))
    data_json.each do |data|
      data['embeds'].each do |bed|
        title = bed['title']
        list_sale = DasListSale.find_or_initialize_by(list_discord_id: data['id'], domain: title[/(?<=\*\* ).*(?= \*\*)/])
        list_sale.list_time = data['timestamp'].to_datetime
        list_sale.list_ckb_price = title[/(?<=listed for ).*(?= CKB\()/].gsub(',', '')
        list_sale.list_price = title[/(?<= CKB\(\$).*(?=\)\. Buy Now)/].gsub(',', '')
        list_sale.save if list_sale.changed?
      end
    end
  end

  def self.get_sale_account
    last_id = DasListSale.where.not(sale_time: nil).order('sale_time desc').first&.sale_discord_id || 0
    sale_url = "https://discord.com/api/v9/channels/895974896444780564/messages?limit=100&after=#{last_id}"
    data_json = JSON.parse(RestClient.get(sale_url, headers=HEADER))
    data_json.each do |data|
      content = data['content']
      list_sale = DasListSale.where(domain: content[/(?<=\*\* ).*(?= \*\*)/], is_list: true).last || DasListSale.new(domain: content[/(?<=\*\* ).*(?= \*\*)/])
      list_sale.is_list = false
      list_sale.sale_discord_id = data['id']
      list_sale.sale_time = data['timestamp'].to_datetime
      list_sale.final_price = content[/(?<=CKB\(\$).*(?=\).)/].gsub(',', '')
      list_sale.final_ckb_price = content[/(?<=bought for ).*(?= CKB\(\$)/].gsub(',', '')
      list_sale.save if list_sale.changed?
    end
  end
  
end
