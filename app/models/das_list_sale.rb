class DasListSale < ApplicationRecord
  belongs_to :das_account, optional: true

  before_create do
    self.das_accoount_id = DasAccount.find_by(domain: self.domain)&.id
  end

  after_save do

  end

end
