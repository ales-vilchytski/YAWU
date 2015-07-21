class JS::Pretty

  def initialize(opts)
    @options = {
        indent_num: 2
    }.merge(opts)

    @json = JavaUtil::JSEvaluator.new
    @json.eval_js(%q{
      function indent(jsString, indentSpaces) {
          var obj = JSON.parse(jsString);
          return JSON.stringify(obj, null, indentSpaces);
      }
    });
  end

  def prettify(arg)
    @json.indent(arg, @options[:indent_num]);
  end

end

