# frozen_string_literal: true
namespace :discord do

  desc "获取das account"
  task get_das_acount: :environment do
    print "get_das_list begin\n"
    begin
      DasAccount.get_das_account
      DasAccount.get_list_account
      DasAccount.get_sale_account
    rescue Exception => e
      print e
    end
    print "get_das_list end\n"
  end

  desc "发推"
  task post_twitter: :environment do
    print "check post twitter begin\n"
    begin
      DasListSale.check_post_twitter
    rescue Exception => e
      print e
    end
    print "check post twitter end\n"
  end



end

