# frozen_string_literal: true
namespace :discord do

  task get_das_acount: :environment do
    print "get_das_lsit\n"
    begin
      DasAccount.get_das_account
      DasAccount.get_list_account
      DasAccount.get_sale_account
    rescue Exception => e
      print e
    end
  end

  task post_twitter: :environment do
    print "check post twitter\n"
    begin
      DasListSale.check_post_twitter
    rescue Exception => e
      print e
    end
  end



end

