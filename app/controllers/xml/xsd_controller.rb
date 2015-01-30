module Xml

  class XsdController < EditorController
    include Uploads::Uploadable
    
    upload_class Uploads::Xml::XsdFile
    
    def editor
      @files = Uploads::Xml::XsdFile.all
      
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def validate
      result = execute_for_json do |r|
        xsd_string = if (params[:mode] == 'file')
          Uploads::Xml::XsdFile.find(params[:file]).read
        else
          params[:xsd]
        end
        
        xsd = Xml::Xsd.new(xsd_string)
        
        errors = xsd.validate(params[:xml])
        r[:result] = errors.empty? ? t('xml.xsd.valid') : errors.join("\n")
      end
      
      respond_to do |format|
        format.json { render :json => result }
      end
    end
    
  end
    
end