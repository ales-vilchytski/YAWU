module Xml
  
  class XpathController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def xpath
      result = execute_for_json do |r|
        xpath_evaluator = Xml::Xpath.new
        r[:result] = xpath_evaluator.evaluate(params[:xml], params[:xpath])
      end
      
      respond_to do |format|
        format.json { render json: result }
      end
    end
    
  end
  
end