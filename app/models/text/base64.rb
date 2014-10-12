class Text::Base64

  def encode(arg)
    Base64.encode64 arg
  end
  
  def decode(arg)
    Base64.decode64 arg
  end

end

