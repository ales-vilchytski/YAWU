# encoding: utf-8
module Xml

  class XmldsigController < EditorController
    include Uploads::Uploadable
    
    upload_class :bicrypt_file
    
    def editor
      @files = Uploads::BicryptFile.all
      respond_to do |format|
        format.html { render :editor }
      end
    end

    def sign
      result = execute_for_json do |r|
        case params[:provider]
          when 'bicrypt_fpsu'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_fpsu(
                params[:xml],
                params[:bicrypt_fpsu_host],
                params[:bicrypt_fpsu_port],
                params[:bicrypt_fpsu_timeout],
                params[:bicrypt_fpsu_key_number]
            )
          when 'bicrypt_local_double_component_key'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_double_component(
                params[:xml],
                (Uploads::BicryptFile.find(params[:bicrypt_local_pk_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_double_mk_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_gk_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_uz_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_prnd_file])).uploaded.path
            )
          when 'bicrypt_local_single_component_key'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_single_component(
                params[:xml],
                (Uploads::BicryptFile.find(params[:bicrypt_local_pk_file])).uploaded.path,
                params[:bicrypt_local_single_pk_password],
                (Uploads::BicryptFile.find(params[:bicrypt_local_gk_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_uz_file])).uploaded.path,
                (Uploads::BicryptFile.find(params[:bicrypt_local_prnd_file])).uploaded.path
            )
          when 'rsa'
            r[:result] = Xml::Xmldsig::sign_xml_with_rsa(
                params[:xml],
                (Uploads::BicryptFile.find(params[:rsa_pkcs12_file])).uploaded.path,
                params[:rsa_pkcs12_password]
            )

        end
      end

      respond_to do |format|
        format.json { render :json => result }
      end
    end

  end

end