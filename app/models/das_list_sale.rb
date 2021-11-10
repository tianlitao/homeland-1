class DasListSale < ApplicationRecord
  belongs_to :das_account, optional: true

  before_create do
    self.das_accoount_id = DasAccount.find_by(domain: self.domain)&.id
  end

  before_save do
    if self.sale_time.present? && self.sale_time_changed?
      self.twitter_sale = false
    end

    if self.list_time.present? && self.list_time_changed? && self.filter_list
      self.twitter_list = false
    end

  end

  def self.check_post_twitter
    if sale = DasListSale.where(twitter_sale: false).order("sale_time desc").first
      $twitter_client.update(sale.final_twitter)
      sale.update(twitter_sale: true)
      return true
    end
    if sale = DasListSale.where(twitter_list: false).order("list_time desc").first
      $twitter_client.update(sale.list_twitter)
      sale.update(twitter_list: true)
      return true
    end
    return false
  end

  def final_twitter
    "🎉🎉 Wow, #{self.domain} bought for #{self.final_ckb_price} CKB($#{self.final_price}), yield: #{("%.2f" % (self.final_price.to_f*100/5.0))}%. Visit https://das.la/​, claim a better DAS Account. #domains #das $CKB"
  end

  def list_twitter
    "|￣￣￣￣￣￣￣￣￣￣￣￣￣|
    🚀Buy #{self.domain}!
|＿＿＿＿＿＿＿＿＿＿＿＿＿|
                   \\ (👀) /
                     \\      /
                      ——
                       |_   |_
#domains #NFTs ​https://bestdas.com/account/#{URI::encode(self.domain)}?inviter=cryptofans.bit​"
  end

  def filter_list
    depth = self.domain.gsub('.bit', '').strip.size
    case
      when depth >= 8 || self.list_ckb_price < 1000
        return false
      when depth >= 5 && self.list_ckb_price > 1000000
        return false
      when depth >= 4 && self.list_ckb_price > 5000000
        return false
      else
        return true
    end
  end

end
