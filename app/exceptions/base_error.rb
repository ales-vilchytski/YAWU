# Base class for application exceptions. Uses localization + arguments for interpolation
# instead of plain exception messages
class BaseError < StandardError
  
  def initialize(arguments = {}, subtype = nil)
    msg = I18n.t("exceptions.#{self.class.name.underscore}" + (subtype ? ".#{subtype}" : ''), arguments)
    super(msg)
  end
  
end
