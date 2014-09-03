# encoding: utf-8
module Xml

  class XmldsigController < EditorController
    FILES_DIRECTORY = (Rails.public_path + 'uploads/')

    def editor
      respond_to do |format|
        logger.debug FILES_DIRECTORY
        @files = []
        Dir.foreach(FILES_DIRECTORY) do |file_name|
          next if file_name == '.' or file_name == '..'
          logger.debug file_name
          @files.push(file_name.encode('utf-8', :invalid => :replace))
        end
        format.html { render :editor }
      end
    end

    def file_upload
      result = execute_for_json do |r|
        r[:files] = []

        params[:files].each do |file|
          name = file.original_filename
          logger.debug name
          path = File.join(FILES_DIRECTORY, name)
          File.open(path, 'wb') { |f| f.write(file.read) }
          logger.debug 'File uploaded: ' + name
          r[:files].push({name: name})
        end
      end

      respond_to do |format|
        format.json { render :json => result }
      end
    end

    def xmldsig
      result = execute_for_json do |r|
        case params[:provider]
          when 'bicrypt_fpsu'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_fpsu(
                params[:xml],
                params[:bicrypt_fpsu_host],
                params[:bicrypt_fpsu_port],
                params[:bicrypt_fpsu_timeout],
                params[:bicrypt_fpsu_key_number],
            )
          when 'bicrypt_local_double_component_key'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_double_component(
                params[:xml],
                (FILES_DIRECTORY + params[:bicrypt_local_pk_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_double_mk_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_gk_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_uz_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_prnd_file]).to_path,
            )
          when 'bicrypt_local_single_component_key'
            r[:result] = Xml::Xmldsig::sign_xml_with_bicrypt_single_component(
                params[:xml],
                (FILES_DIRECTORY + params[:bicrypt_local_pk_file]).to_path,
                params[:bicrypt_local_single_pk_password],
                (FILES_DIRECTORY + params[:bicrypt_local_gk_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_uz_file]).to_path,
                (FILES_DIRECTORY + params[:bicrypt_local_prnd_file]).to_path,
            )
          when 'rsa'
            r[:result] = Xml::Xmldsig::sign_xml_with_rsa(
                params[:xml],
                (FILES_DIRECTORY + params[:rsa_pkcs12_file]).to_path,
                params[:rsa_pkcs12_password],
            )

        end
      end

      respond_to do |format|
        format.json { render :json => result }
      end
    end

  end

end