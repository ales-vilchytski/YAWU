# encoding: utf-8
require 'java'
require 'jars/xalan-2.7.1.jar'
require 'jars/axis-1.4.jar'

module XmlUtils
  java_import 'java.io.ByteArrayInputStream';
  java_import 'java.io.IOException';
  java_import 'java.io.StringReader';
  java_import 'java.io.StringWriter';
  java_import 'java.io.Writer';
  java_import 'java.security.PrivateKey';
  java_import 'java.security.Provider';
  java_import 'java.security.cert.CertificateException';
  java_import 'java.security.cert.CertificateFactory';
  java_import 'java.security.cert.X509Certificate';
  java_import 'java.util.ArrayList';
  java_import 'java.util.Collections';
  java_import 'java.util.HashMap';
  java_import 'java.util.List';
  java_import 'java.util.Map';

  java_import 'javax.xml.crypto.KeySelector';
  java_import 'javax.xml.crypto.MarshalException';
  java_import 'javax.xml.crypto.dsig.CanonicalizationMethod';
  java_import 'javax.xml.crypto.dsig.Reference';
  java_import 'javax.xml.crypto.dsig.SignedInfo';
  java_import 'javax.xml.crypto.dsig.Transform';
  java_import 'javax.xml.crypto.dsig.XMLSignatureException';
  java_import 'javax.xml.crypto.dsig.XMLSignatureFactory';
  java_import 'javax.xml.crypto.dsig.dom.DOMSignContext';
  java_import 'javax.xml.crypto.dsig.dom.DOMValidateContext';
  java_import 'javax.xml.crypto.dsig.keyinfo.KeyInfoFactory';
  java_import 'javax.xml.crypto.dsig.keyinfo.X509Data';
  java_import 'javax.xml.crypto.dsig.spec.C14NMethodParameterSpec';
  java_import 'javax.xml.crypto.dsig.spec.TransformParameterSpec';
  java_import 'javax.xml.parsers.DocumentBuilder';
  java_import 'javax.xml.parsers.DocumentBuilderFactory';
  java_import 'javax.xml.parsers.ParserConfigurationException';
  java_import 'javax.xml.soap.SOAPBody';
  java_import 'javax.xml.soap.SOAPEnvelope';
  java_import 'javax.xml.soap.SOAPException';
  java_import 'javax.xml.soap.SOAPMessage';
  java_import 'javax.xml.soap.SOAPPart';
  java_import 'javax.xml.transform.Transformer';
  java_import 'javax.xml.transform.TransformerException';
  java_import 'javax.xml.transform.TransformerFactory';
  java_import 'javax.xml.transform.dom.DOMSource';
  java_import 'javax.xml.transform.stream.StreamResult';

  #java_import 'org.apache.axis.utils.XMLUtils';
  java_import 'org.apache.ws.security.WSSecurityException';
  java_import 'org.apache.ws.security.message.WSSecHeader';
  java_import 'org.apache.ws.security.message.token.X509Security';
  #java_import 'org.apache.ws.security.util.XMLUtils';
  java_import 'org.apache.xml.security.exceptions.XMLSecurityException';
  java_import 'org.apache.xml.security.keys.KeyInfo';
  java_import 'org.apache.xml.security.signature.XMLSignature';
  java_import 'org.apache.xml.security.transforms.Transforms';
  java_import 'org.apache.xml.security.utils.Constants';
  java_import 'org.apache.xpath.XPathAPI';
  java_import 'org.w3c.dom.Attr';
  java_import 'org.w3c.dom.Document';
  java_import 'org.w3c.dom.Element';
  java_import 'org.w3c.dom.Node';
  java_import 'org.w3c.dom.NodeList';
  java_import 'org.xml.sax.InputSource';
  java_import 'org.xml.sax.SAXException';
  java_import 'javax.xml.transform.OutputKeys'

  class << self
    CONTEXT_SIGNATURE_PROVIDER_PARAM_NAME = "org.jcp.xml.dsig.internal.dom.SignatureProvider";
    SOAP_NS_URI = "http://schemas.xmlsoap.org/soap/envelope/";
    DS_NS_URI = "http://www.w3.org/2000/09/xmldsig#";
    WSU_NS_URI = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd";
    WSSE_NS_URI = "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd";

    def sign_xml(xml, node_uri, private_key, signature_method_uri, digest_method_uri, cert = nil)
      document_builder = create_document_builder;
      doc = document_builder.parse(InputSource.new(StringReader.new(xml)))
      sig = XMLSignature.new(doc, node_uri, signature_method_uri)
      root_element = doc.getDocumentElement();
      root_element.appendChild(sig.getElement());
      transforms = Transforms.new(doc);

      transforms.addTransform(Transforms::TRANSFORM_ENVELOPED_SIGNATURE);
      transforms.addTransform(Transforms::TRANSFORM_C14N_WITH_COMMENTS);

      sig.addDocument(node_uri, transforms, digest_method_uri);

      if cert != nil
        sig.addKeyInfo(cert);
      end

      sig.sign(private_key);
      return serialize_xml_document(doc)
    end

    def sign_soap(soap_message, xmldsig_provider, signature_provider, node_uri, wsu_id = 'body',
        private_key, actor, signature_method_uri, digest_method_uri, canonicalization_method_uri, certificate)
      soap_part = soap_message.getSOAPPart();
      soap_envelope = soap_part.getEnvelope();
      soap_body = soap_envelope.getBody();
      doc = soap_envelope.getOwnerDocument();

      # Prepare secured header
      soap_envelope.addNamespaceDeclaration("wsse", WSSE_NS_URI);
      soap_envelope.addNamespaceDeclaration("wsu", WSU_NS_URI);
      soap_envelope.addNamespaceDeclaration("ds", DS_NS_URI);

      sign_element = nil;
      if (node_uri != nil)
        sign_element = soap_body;
      else
        sign_element = XPathAPI.selectSingleNode(doc, node_uri);
        if sign_element == nil
          raise 'Не найден подписываемый элемент ' + node_uri;
        end
      end

      sign_element.setAttributeNS(WSU_NS_URI, "wsu:Id", wsu_id);
      id_attr = sign_element.getAttributeNode("wsu:Id");
      sign_element.setIdAttributeNode(id_attr, true);

      ws_header = WSSecHeader.new();
      ws_header.setActor(actor);
      ws_header.setMustUnderstand(false);

      sec = ws_header.insertSecurityHeader(soap_part);
      token = sec.appendChild(doc.createElementNS(WSSE_NS_URI, "wsse:BinarySecurityToken"));
      token.setAttribute("EncodingType", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary");
      token.setAttribute("ValueType", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3");
      token.setAttribute("wsu:Id", "SenderCertificate");
      ws_header.getSecurityHeader().appendChild(token);

      sig_factory = XMLSignatureFactory.getInstance("DOM", xmldsig_provider);

      if (canonicalization_method_uri == nil || canonicalization_method_uri.empty?)
        canonicalizationMethod = Transforms::TRANSFORM_C14N11_WITH_COMMENTS;
      end

      transform_list = Java::ArrayList.new;
      transform_list.add(sig_factory.newTransform(canonicalizationMethod, nil));
      ref = sig_factory.newReference(
          "#" + wsu_id,
          sig_factory.newDigestMethod(digest_method_uri, nil),
          transform_list, nil, nil
      );

      signed_info = sig_factory.newSignedInfo(
          sig_factory.newCanonicalizationMethod(CanonicalizationMethod::EXCLUSIVE, nil),
          sig_factory.newSignatureMethod(signature_method_uri, null),
          Collections.singletonList(ref)
      );

      kif = sig_factory.getKeyInfoFactory();
      x509d = kif.newX509Data(Collections.singletonList(certificate));
      ki = kif.newKeyInfo(Collections.singletonList(x509d));
      sig = sig_factory.newXMLSignature(signed_info, ki);
      sig_context = new DOMSignContext(private_key, token);
      # sigContext.putNamespacePrefix(XMLSignature.XMLNS, "ds");
      sig_context.setProperty(CONTEXT_SIGNATURE_PROVIDER_PARAM_NAME, signature_provider);
      sig_context.setDefaultNamespacePrefix("ds");

      sig.sign(sig_context);

      # Узел подписи Signature.
      sig_element = XPathAPI.selectSingleNode(sig_context.getParent(), "//ds:Signature");
      # Блок данных KeyInfo.
      key_element = XPathAPI.selectSingleNode(sig_element, "//ds:KeyInfo", sig_element);
      # Добавляем в BinarySecurityToken значение сертификата
      cert_value = XPathAPI.selectSingleNode(key_element, "//ds:X509Certificate", key_element).getFirstChild().getNodeValue();
      token.setTextContent(cert_value);

      # Удаляем содержимое KeyInfo
      chl = key_element.getChildNodes();
      (0..chl.getLength()).each do |i|
        key_element.removeChild(chl.item(i));
      end

      # Узел KeyInfo содержит указание на проверку подписи с помощью сертификата SenderCertificate.
      str = key_element.appendChild(doc.createElementNS(WSSE_NS_URI, "wsse:SecurityTokenReference"));
      strRef = str.appendChild(doc.createElementNS(WSSE_NS_URI, "wsse:Reference"));
      strRef.setAttribute("ValueType", "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3");
      strRef.setAttribute("URI", "#SenderCertificate");
      ws_header.getSecurityHeader().appendChild(sig_element);

    end

    def create_document_builder
      dbf = DocumentBuilderFactory.newInstance();
      dbf.setIgnoringElementContentWhitespace(true);
      dbf.setCoalescing(true);
      dbf.setNamespaceAware(true);
      return dbf.newDocumentBuilder();
    end

    def serialize_xml_document(doc)
      transformer = TransformerFactory.newInstance().newTransformer();
      string_writer = StringWriter.new
      output = StreamResult.new(string_writer);
      input = DOMSource.new(doc);
      transformer.transform(input, output);
      return string_writer.toString();
      #return org::apache::axis::utils::XMLUtils.DocumentToString(doc);
    end
    
    def parse_string_to_jdom(xml)
      return create_jdom_builder.parse(InputSource.new(StringReader.new(xml)));
    end
    
    def create_jdom_builder
      docBuilderF = DocumentBuilderFactory.newInstance();
      docBuilderF.setNamespaceAware(true);
      return docBuilderF.newDocumentBuilder();
    end
    
    def jdom_to_string(dom)
      transformer = TransformerFactory.newInstance().newTransformer();
      strWriter = StringWriter.new
      output = StreamResult.new(strWriter);
      input = DOMSource.new(dom);
      transformer.transform(input, output);
      return strWriter.toString();
    end
    
    def transform_docs(xslt_doc, xml_doc, transformer_class = 'org.apache.xalan.processor.TransformerFactoryImpl')
      xslt_source = DOMSource.new(xslt_doc)
      transformer = TransformerFactory.newInstance(transformer_class, nil).newTransformer(xslt_source);
      string_writer = StringWriter.new
      output = StreamResult.new(string_writer);
      input = DOMSource.new(xml_doc);
      transformer.transform(input, output);
      return string_writer.toString();
    end
    
    def transform_text(xslt, xml, transformer_class = 'org.apache.xalan.processor.TransformerFactoryImpl')
      xslt_doc = parse_string_to_jdom(xslt)
      xml_doc = parse_string_to_jdom(xml);
      return transform_docs(xslt_doc, xml_doc);
    end
    
  end
end

