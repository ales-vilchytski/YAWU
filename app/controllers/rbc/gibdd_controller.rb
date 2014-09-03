# encoding: utf-8

module Rbc
  
  class GibddController < EditorController
  
    def editor      
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def process_uin      
      result = execute_for_json do |r|
        opts = {
          type: 'OLD',
          mode: 'GENERATE',
        }.merge(nothing_if_empty_or_nil({
            input: params[:input],
            type: params[:type],
            mode: params[:mode],
          })
        );
        
        gibdd = Rbc::Gibdd.new
        
        case opts[:mode]
        when 'GENERATE'
          
          r[:result] = \
          case opts[:type]
          when 'OLD'
            gibdd.generate_old_rand_uin
          when 'NEW'
            gibdd.generate_new_rand_uin
          else
            raise 'Неизвестный тип УИНа'
          end
        
        when 'PARSE'
          res = gibdd.parse_old_uin(opts[:input])
          r[:result] = "#{res[:num_post]} #{res[:date_post]}"
          
        when 'CHECKSUM'
          r[:result] = opts[:input] + gibdd.calc_checksum(opts[:input])
        
        else
          raise 'Неподдерживаемый режим работы'
        end
        
      end
            
      respond_to do |format|
        format.json { render json: result }
      end
    end
  
  end
end