# Simple wrapper for test-files. Add files (in UTF-8) to `@@base_path` to access them
# Usecases:
# 1. Retrieve TestFile instance:
#      test_xml = TestFile['xml/catalog.xml']
# 2. Get file's absolute path and upload  it:
#      path = TestFile['foo/bar.baz'].path
#      attach_file('#fileinput', path)
# 3. Get file's content and fill in input:
#      content = TestFile['baz/bar.foo'].text
#      fill_in('#field', with: content)
class TestFile
  @@base_path = File.join(Rails.root, 'spec/test_files/')
  
  attr_reader :name, :path, :relative_path, :text
  
  def initialize(name, path, relative_path)
    @name = name
    @path = path
    @relative_path = relative_path
    @text = nil
  end
  
  def text
    if !@text
      @text = File.open(path, 'r:utf-8').read.freeze
    end
    return @text
  end
  
  def to_s
    text
  end
  
  
  @@files = nil
  def self.files
    if (!@@files)
      @@files = {}
      prefix = @@base_path
      Dir.glob(prefix + '**/*') do |absolute_path|
        name = absolute_path.split(/(\/)|(\\)/).last
        rpath = absolute_path.gsub(prefix, '')
        # For WebDriver
        # File path should contain system specific path-separator. For Windows it's '\'
        path = absolute_path.gsub('/', File::ALT_SEPARATOR || File::SEPARATOR)
        
        @@files[rpath] = TestFile.new(name, path, rpath)
      end
    end
    return @@files
  end
  
  def self.[](rel_path)
    return files[rel_path] || (raise "Test file '#{rel_path}' not found")
  end  
  
end