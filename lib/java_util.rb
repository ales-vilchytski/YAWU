# encoding: utf-8
require 'java'

module JavaUtil
  # Uses JSR223 to evaluating JavaScript files and accessing JS functions.
  # Evaluates JS-file in project or script (if specified) and provides calls to functions in script.
  # E.g.:
  #   e = JSEvaluator.new('lib/factorial.js').factorial(1)
  #   # or reuse instance:
  #   res = e.eval_js_file('arrays.js')
  #   e.createArray(1,2,3,4)
  class JSEvaluator
    def initialize(path = nil)
      if (path)
        eval_js_file(path)
      end
    end

    def eval_js_file(path)
      result = nil
      File.open(File.expand_path(path), 'r:utf-8') do |file|
        result = self.eval_js(file.read)
      end
      return result
    end

    def eval_js(script)
      scriptEngineMgr = javax.script.ScriptEngineManager.new
      @jsEngine = scriptEngineMgr.getEngineByName('javascript')

      @jsEngine.eval(script)
    end

    def method_missing(method, *args, &block)
      self.invoke_function(method, *args)
    end

    def invoke_function(method, *args)
      @jsEngine.invokeFunction(method.to_s, *args)
    end

  end

end
