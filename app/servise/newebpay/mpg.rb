module Newebpay
  class Mpg
    attr_accessor :info

    def initialize
      # 建議 hash key / iv & merchant id 都使用環境變數
      @key = ENV["hash_key"]
      @iv = ENV["hash_iv"]
      @merchant_id = "MS148637229"
      @info = {}  # 使用 attr_accessor 讓 info 方便存取
      set_info
    end

    def form_info
      {  #MPG交易請求之參數
        MerchantID: @merchant_id,
        TradeInfo: trade_info,
        TradeSha: trade_sha,
        Version: "2.0"
      }
    end

    private
    def trade_info
      aes_encode(url_encoded_query_string)
    end

    def trade_sha
      sha256_encode(@key, @iv, trade_info)
    end

    def set_info
      info[:MerchantID] = @merchant_id   #勿動
      info[:MerchantOrderNo] = Time.now.strftime("%Y%m%d%H%M%S")   #訂單編號，可更改
      info[:Amt] = "1000"               #金額 需更改  order.amount之類的
      info[:ItemDesc] = "Marche"        #商品名稱 需更改   order.name之類的
      info[:Email] = "kg936512@yahoo.com.tw"    #客戶的信箱，非常的莫名其妙，就算關閉此欄位，藍新結帳頁面依然會出現，須填完才可送出完成交易，所以需更改“
      info[:TimeStamp] = Time.now.to_i   
      info[:RespondType] = "JSON"        #勿動
      info[:Version] = "2.0"             #勿動
      info[:LoginType] = 0               #勿動
      info[:CREDIT] =  1                 #勿動
    end

    def url_encoded_query_string
      URI.encode_www_form(info)
    end

    def aes_encode(string)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt
      cipher.key = @key
      cipher.iv = @iv
      cipher.padding = 0
      padding_data = add_padding(string)
      encrypted = cipher.update(padding_data) + cipher.final
      encrypted.unpack('H*').first
    end

    def add_padding(data, block_size = 32)
      pad = block_size - (data.length % block_size)
      data + (pad.chr * pad)
    end

    def sha256_encode(key, iv, trade_info)
      encode_string = "HashKey=#{key}&#{trade_info}&HashIV=#{iv}"
      Digest::SHA256.hexdigest(encode_string).upcase
    end
  end
end