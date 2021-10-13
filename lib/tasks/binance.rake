# frozen_string_literal: true
namespace :binance do

  task snatch_article: :environment do
    print "search binance topic"
    res = Nokogiri::HTML  RestClient.get('https://www.binance.com/zh-CN/support/announcement/c-48?navId=48').body
    first_text = res.css('a.css-1ej4hfo')[0].text.to_s
    if first_text.include?('币安上市') && !first_text.include?('RARE')

      url = "https://sctapi.ftqq.com/SCT83964TIkzGyqCjO8WN2EsrXbgBLUh8.send?title=#{first_text}"
      begin
        RestClient.get(URI.encode url)
      rescue Exception => e
        print e
      end

      begin
        v2_order(first_text[/\（(.*?)\）/, 1])
      rescue Exception => e
        print e
      end
    end
  end

  def v2_order(pair = '')
    print pair
    return if pair.blank?
    all_pairs_url = 'https://data.gateapi.io/api2/1/marketinfo'
    get_balance_url = 'https://api.gateio.la/api2/1/private/balances'
    get_order_book_url = 'https://data.gateapi.io/api2/1/orderBook/'
    buy_url = 'https://api.gateio.la/api2/1/private/buy'

    pair = "#{pair.upcase}_USDT"

    all_pair = JSON.parse RestClient.get(all_pairs_url).body
    if current_pair = all_pair['pairs'].find{|i| i[pair.downcase]}
      decimal = current_pair[pair.downcase]['amount_decimal_places'] - 1
      balance = JSON.parse RestClient.post(get_balance_url, {}, gen_sign({})).body
      while (balance['result'] == 'true' && balance['available']['USDT'].to_f >= 5) do
        order_book = JSON.parse RestClient.get(get_order_book_url + pair).body
        price = order_book['asks'][-2][0]

        params = {'currencyPair' => pair.downcase, 'rate' => price, 'amount' => (balance['available']['USDT'].to_f/price.to_f).round(decimal), 'orderType' => 'ioc'}
        buy = JSON.parse RestClient.post(buy_url, params, gen_sign(params)).body

        balance = JSON.parse RestClient.post(get_balance_url, {}, gen_sign({})).body
      end

    end
  end

  def gen_sign(param)
    key = '11'
    secret = '22'
    i = ''
    param.map{|k,v| i += "#{k}=#{v}&"}
    {'KEY' => key, 'SIGN' => OpenSSL::HMAC.hexdigest("SHA512", secret, i[0..-2]), 'Content-Type' => 'application/x-www-form-urlencoded'}
  end

  # def gen_sign(method, url, query_string = '', payload_string = '')
  #   key = '56a9830cae008e93fb2a9a19933478ca'
  #   secret = '548e6d8bf4cf7ee1808f3da0d672e5ad97ef5e8164c6820d2469da2cdaa8a54b'
  #   time = Time.now.to_i
  #   sign = method + "\n" + url + "\n" + query_string + "\n" + Digest::SHA2.new(512).hexdigest(payload_string) + "\n" + time.to_s
  #   {'KEY' => key, 'Timestamp' => time.to_s, 'SIGN' =>  OpenSSL::HMAC.hexdigest("SHA512", secret, sign)}
  # end

  # def v4_order
  #   host = "https://api.gateio.ws"
  #   prefix = "/api/v4"
  #   #全部币种信息
  #   all_pairs_url =  "https://api.gateio.ws/api/v4/spot/currency_pairs"
  #   all_pair = JSON.parse RestClient.get(all_pairs_url).body
  #
  #
  #
  #   #查询余额
  #   my_url = '/spot/accounts'
  #   sign_headers = gen_sign('GET', prefix + my_url, '')
  #   headers = {'Accept' => 'application/json', 'Content-Type' => 'application/json'}
  #   accounts = JSON.parse RestClient.get(host + prefix + my_url, headers=headers.merge(sign_headers)).body
  #   usdt_acount = accounts.find{|i| i['currency'] == 'USDT'}['available'].to_f #usdt 余额
  #
  #   #最新挂单情况
  #   order_book_url = "https://api.gateio.ws/api/v4/spot/order_book?currency_pair=BTC_USDT"
  #   last_order = JSON.parse RestClient.get(order_book_url).body
  #   price = last_order['asks'][1][0].to_f
  #
  #   order_url = "/spot/orders"
    # body = {"text" => 't-111111',
    #         "currency_pair" => 'BTC_USDT',
    #         "type" => 'limit',
    #         "account" => 'spot',
    #         "side" => 'buy',
    #         "iceberg" => -1,
    #         "amount" => 0.0001,
    #         "price" => price,
    #         "time_in_force" => "ioc",
    #         "auto_borrow" => false}
    # body = {
    #     "text" => "t-123456",
    #     "currency_pair"=> "BTC_USDT",
    #     "type"=> "limit",
    #     "account"=> "spot",
    #     "side"=> "buy",
    #     "iceberg"=> "0",
    #     "amount"=> "0.00001",
    #     "price"=> "5.00032",
    #     "time_in_force"=> "gtc",
    #     "auto_borrow"=> false
    # }
  #   host = "https://api.gateio.ws"
  #   prefix = "/api/v4"
  #   url = '/wallet/transfers'
  #   body = {"currency" => "BTC",
  #       "from" => "spot",
  #       "to" => "margin",
  #       "amount" => "1",
  #       "currency_pair" => "BTC_USDT"
  #   }
  #
  #   {"currency": "BTC","from": "spot","to": "margin","amount": "1", "currency_pair": "BTC_USDT"}
  #   sign_headers = gen_sign('POST', prefix + url, '', body.to_json)
  #   order = JSON.parse RestClient.post(host + prefix + url, body, headers.merge(sign_headers)).body
  # end

end

