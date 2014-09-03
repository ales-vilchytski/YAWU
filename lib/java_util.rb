# encoding: utf-8

module JavaUtil
  # Использует JSR223 для доступа к JavaScript файлам - выполнению и вызову JS-функций
  # Конструкто выполняет JS файл в проекте (если указан), после чего возможен вызов
  # объявленных в скрипте функций (посредством method_missing)
  #  Например:
  #  e = JSEvaluator.new('lib/factorial.js').factorial(1)
  #  res = e.eval_js_file('arrays.js')
  #  e.createArray(1,2,3,4)
  class JSEvaluator
    def initialize(path = nil)
      if (path)
        eval_js_file(path)
      end
    end

    def eval_js_file(path)
      result = nil
      File.open(File.expand_path(path), 'r:utf-8') do |file|
        scriptEngineMgr = javax.script.ScriptEngineManager.new
        @jsEngine = scriptEngineMgr.getEngineByName('javascript')

        result = @jsEngine.eval(file.read)
      end
      return result
    end

    def method_missing(method, *args, &block)
      invoke_function(method, *args)
    end

    def invoke_function(method, *args)
      @jsEngine.invokeFunction(method.to_s, *args)
    end

  end

end