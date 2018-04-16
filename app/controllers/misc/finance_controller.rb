class Misc::FinanceController < EditorController

  @@input = '2018-01-01:: о1.2 прод20'
  @@output = ''
  @@num_to_dollar_rate = 2

  # GET /misc/finance
  def editor
    @input = @@input
    @output = @@output
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /misc/finance/parse_string_to_table
  def parse_string_to_table
    result = execute_for_json do |r|
      r[:result] = @@output = Misc::Finance.new.parse_string_to_table(params[:input], params[:num_to_dollar_rate])
    end

    @@input = params[:input]
    @@num_to_dollar_rate = params[:num_to_dollar_rate]

    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
