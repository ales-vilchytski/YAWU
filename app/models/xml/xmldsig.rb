require 'lib/xml_utils.rb'

module Xml

  class Xmldsig
    java_import 'java.io.FileInputStream'
    java_import 'java.security.Security'

    java_import 'java.security.KeyFactory'
    java_import 'java.security.KeyStore'
    java_import 'java.security.cert.CertificateFactory'
    java_import 'java.security.spec.KeySpec'

    java_import 'javax.xml.crypto.dsig.DigestMethod'
    java_import 'javax.xml.crypto.dsig.SignatureMethod'

    java_import 'by.sberteh.jcp.BicryptJCP'
    java_import 'by.sberteh.jcp.keyspec.BicryptPrivateKeyDoubleComponentSpec'
    java_import 'by.sberteh.jcp.keyspec.BicryptPrivateKeyFpsuSpec'
    java_import 'by.sberteh.jcp.keyspec.BicryptPrivateKeySingleComponentSpec'
    java_import 'by.sberteh.jcp.keyspec.BicryptPublicKeyBokSpec'
    java_import 'by.sberteh.jcp.xml.BicryptXMLDsigInit'
    java_import 'by.sberteh.jcp.xml.dsig.internal.dom.XMLDSigRI'

    class << self

      #attr_accessor :options

      #def initialize
      #@@options = options
      @@signature_provider = BicryptJCP.new
      @@xmldsig_provider = XMLDSigRI.new

      Security.addProvider(@@signature_provider);
      Security.addProvider(@@xmldsig_provider);
      BicryptXMLDsigInit.init();
      #end

      def sign_xml_with_bicrypt_fpsu(xml, fpsu_host, fpsu_port, fpsu_timeout, key_number, cert_file_path = nil)
        bicrypt_private_key_fpsu_spec = BicryptPrivateKeyFpsuSpec.new(
            fpsu_host,
            Integer(fpsu_port),
            Integer(fpsu_timeout),
            Integer(key_number)
        );

        key_factory = KeyFactory.getInstance(BicryptJCP::KEY_ALGORITHM);
        private_key = key_factory.generatePrivate(bicrypt_private_key_fpsu_spec);

        cert = nil
        if (cert_file_path != nil)
          certificate_factory = CertificateFactory.getInstance("X509");
          input_stream = FileInputStream.new(cert_file_path);
          cert = certificate_factory.generateCertificate(input_stream);
        end

        return XmlUtils::sign_xml(
            xml,
            "",
            private_key,
            BicryptJCP::SIGNATURE_ALG_URI,
            BicryptJCP::MESSAGE_DIGEST_ALG_URI,
            cert
        )
      end

      def sign_xml_with_bicrypt_double_component(xml, pk_file_path, mk_file_path, gk_file_path, uz_file_path, prnd_file_path, cert_file_path = nil)
        key_spec = BicryptPrivateKeyDoubleComponentSpec.new(
            pk_file_path,
            mk_file_path,
            gk_file_path,
            uz_file_path,
            prnd_file_path,
        );

        private_key = get_private_key(key_spec);

        cert = nil
        if (cert_file_path != nil)
          cert = get_cert(cert_file_path)
        end

        return XmlUtils::sign_xml(
            xml,
            "",
            private_key,
            BicryptJCP::SIGNATURE_ALG_URI,
            BicryptJCP::MESSAGE_DIGEST_ALG_URI,
            cert
        )
      end

      def sign_xml_with_bicrypt_single_component(xml, pk_file_path, password, gk_file_path, uz_file_path, prnd_file_path, cert_file_path = nil)
        key_spec = BicryptPrivateKeySingleComponentSpec.new(
            pk_file_path,
            password,
            gk_file_path,
            uz_file_path,
            prnd_file_path,
        );

        private_key = get_private_key(key_spec);

        cert = nil
        if (cert_file_path != nil)
          cert = get_cert(cert_file_path)
        end

        return XmlUtils::sign_xml(
            xml,
            '',
            private_key,
            BicryptJCP::SIGNATURE_ALG_URI,
            BicryptJCP::MESSAGE_DIGEST_ALG_URI,
            cert
        )
      end

      def sign_xml_with_rsa(xml, pkcs12_file_path, pkcs12_password, cert_file_path = nil)
        pkcs12_password_java_chars = to_java_chars(pkcs12_password)
        key_store = KeyStore.getInstance("pkcs12");
        key_store.load(FileInputStream.new(pkcs12_file_path), pkcs12_password_java_chars);

        private_key = key_store.getKey(key_store.aliases().first, pkcs12_password_java_chars);

        cert = nil
        if (cert_file_path != nil)
          cert = get_cert(cert_file_path)
        end

        return XmlUtils::sign_xml(
            xml,
            '',
            private_key,
            SignatureMethod::RSA_SHA1,
            DigestMethod::SHA1,
            cert
        )
      end

      def get_cert(cert_file_path)
        certificate_factory = CertificateFactory.getInstance("X509");
        input_stream = FileInputStream.new(cert_file_path);
        return certificate_factory.generateCertificate(input_stream)
      end

      def get_private_key(private_key_spec)
        key_factory = KeyFactory.getInstance(BicryptJCP::KEY_ALGORITHM);
        return key_factory.generatePrivate(private_key_spec);
      end

      def to_java_chars(str)
        result = Java::char[str.bytesize].new
        str.to_java_bytes.each_with_index do |b, index|
          result[index] = b.to_java(Java::char)
        end
        result
      end
    end
  end
end