module Newebpay
  class MpgResponse
    # 使用 attr_reader 可以更方便取用這些資訊
    attr_reader :status, :message, :result, :order_no, :trade_no, :amt, :item_desc, :payment_method
    
    def initialize(params)
      @key = ENV["hash_key"]
      @iv = ENV["hash_iv"]

      response = decrypy(params)
      @result = response["Result"]
      @status = response['Status']
      @order_no = @result["MerchantOrderNo"]    #商店訂單標號
      @trade_no = @result["TradeNo"]    #藍新金流交易序號
      @item_desc = @result["ItemDesc"]
      @payment_method = @result["PaymentMethod"]
      @amt = @result["Amt"]
      # etc...
    end

    def success?
      status === "SUCCESS"
    end

    private
      # AES 解密
      def decrypy(encrypted_data)
        encrypted_data = [encrypted_data].pack('H*')
        decipher = OpenSSL::Cipher::AES256.new(:CBC)
        decipher.decrypt
        decipher.padding = 0
        decipher.key = @key
        decipher.iv = @iv
        data = decipher.update(encrypted_data) + decipher.final
        raw_data = strippadding(data)
        JSON.parse(raw_data)
      end

      def strippadding(data)
        slast = data[-1].ord
        slastc = slast.chr
        string_match = /#{slastc}{#{slast}}/ =~ data
        if !string_match.nil?
          data[0, string_match]
        else
          false
        end
      end
  end
end