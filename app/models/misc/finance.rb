class Misc::Finance

  def parse_string_to_table(str, num_to_dollar_rate)
    js_eval = JavaUtil::JSEvaluator.new
    js_eval.eval_js_file('lib/js/finance.js')
    js_eval.parseStringToTable(str, num_to_dollar_rate)
  end

end

