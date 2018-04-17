class Misc::FinanceController < EditorController

  @@input = '2018-01-01:: abc1.2 qwe20'
  @@output = ''
  @@num_to_dollar_rate = 1.99

  # GET /misc/finance
  def editor
    @input = @@input
    @output = @@output
    @num_to_dollar_rate = @@num_to_dollar_rate
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /misc/finance/parse_string_to_table
  def parse_string_to_table
    input = (params[:input] || '').strip
    result = execute_for_json do |r|
      r[:result] = Misc::Finance.new.parse_string_to_table(input, params[:num_to_dollar_rate])
    end

    @@input = input
    @@output = result[:result]
    @@num_to_dollar_rate = params[:num_to_dollar_rate]

    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
