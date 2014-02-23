module Xml

  class XsdController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def xsd
      result = execute_for_json do |r|
        xsd = Xml::Xsd.new(params[:xsd])
        
        errors = xsd.validate(params[:xml])
        r[:result] = errors.empty? ? t('xml.xsd.valid') : errors.join("\n")
      end
      
      respond_to do |format|
        format.json { render :json => result }
      end
    end
    
  end
    
end