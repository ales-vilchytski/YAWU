class Text::Uuid

  def generate(arg)
    (1..arg).map do
      SecureRandom.uuid()
    end
    .reduce("") do |acc, elem|
      acc += "#{elem}\n"
    end
  end

end

