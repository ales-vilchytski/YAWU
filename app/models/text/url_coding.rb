class Text::UrlCoding

  def encode(arg, encoding = nil)
    if (encoding.present?)
      arg = arg.encode(encoding)
    end
    
    return URI.encode(arg, /\W/)
  end
  
  def decode(arg, encoding = nil)
    res = URI.decode(arg)
    if (encoding.blank?)
      encoding = Encoding.default_external.name
    end
    res.force_encoding(encoding)
    
    return res
  end

end

