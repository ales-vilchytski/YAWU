class Text::Base64

  def encode(arg, encoding)
    if (encoding)
      arg.encode!(encoding)
    end
    
    return Base64.encode64 arg
  end
  
  def decode(arg, encoding)
    res = Base64.decode64 arg
    enc = encoding || Encoding.default_external.name
    res.force_encoding(enc)
    
    return res
  end

end

