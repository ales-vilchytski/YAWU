module Xml

  class XsltController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def transform
      result = execute_for_json do |r|
        xslt = Xml::Xslt.new(params[:xslt])
        
        r[:result] = xslt.transform(params[:xml])
      end
      
      respond_to do |format|
        format.json { render :json => result }
      end
    end
    
  end
    
end