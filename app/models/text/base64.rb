class Text::Base64

  def encode(arg, encoding)
    if (encoding.present?)
      arg.encode!(encoding)
    end
    
    return Base64.encode64(arg)
  end
  
  def decode(arg, encoding)
    res = Base64.decode64 arg
    if (encoding.blank?)
      encoding = Encoding.default_external.name
    end
    res.force_encoding(encoding)
    
    return res
  end

end

