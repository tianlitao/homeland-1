# frozen_string_literal: true
namespace :discord do

  task get_das_acount: :environment do
    print "get_das_lsit"
    begin
      DasAccount.get_das_account
      DasAccount.get_list_account
      DasAccount.get_sale_account
    rescue Exception => e
      print e
    end
  end



end

