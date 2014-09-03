# encoding: utf-8

module Rbc
  
  class RosreestrController < EditorController
  
    def editor      
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def generate
      result = execute_for_json do |r|
        opts = {
          mode: 'text',
          date: (params[:date].nil? || params[:date].empty?) ? (Date.today) : (Date.strptime(params[:date], '%Y-%m-%d')),
        }.merge(nothing_if_empty_or_nil({
            mode: params[:mode]
          })
        );
      
        generator = Rbc::Rosreestr.new
        
        case opts[:mode]
        when 'json'
          r[:result] = JSON.pretty_generate(generator.generate_codes(opts[:date]))
        when 'text'
          r[:result] = generator.generate_codes_txt(opts[:date])
        else
          raise 'Неподдерживаемый режим генерации'
        end
        
      end
            
      respond_to do |format|
        format.json { render json: result }
      end
    end
  
  end
end