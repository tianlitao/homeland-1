class DasListSale < ApplicationRecord
  belongs_to :das_account, optional: true

  before_create do
    self.das_accoount_id = DasAccount.find_by(domain: self.domain)&.id
  end

  after_save do
    if self.sale_time.present? && self.sale_time_changed?
      $twitter_client.update(final_twitter)
    end
  end


  def final_twitter
    "🎉🎉 Wow, #{self.domain} bought for #{self.final_ckb_price} CKB($#{self.final_price}), yield: #{("%.2f" % (self.final_price.to_f*100/5.0))}%. Visit https://das.la/​, claim a better DAS Account. #domains #das $CKB  @realDASystems "
  end

end
