require 'rspec/core/formatters/html_formatter.rb'

class ScrHtml < RSpec::Core::Formatters::HtmlFormatter
  
  def extra_failure_content(exception)
    extra = super(exception)
    example = @examples[@example_number - 1]
    meta = example.metadata
    filename = File.basename(meta[:file_path])
    line_number = meta[:line_number]
    path = "files/FAILED-#{filename}-#{line_number}"
    
    extra + %Q{
      <a href='#{path}.png'>SCREENSHOT</a>
      <br/>
      <a href='#{path}.html'>HTML</a>
    }
  end
  
end