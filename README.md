YAWU - Yet Another Web Utilities
====

Description
---

Rails app with utilities such as JSON converters, HTTP stubs, XSLT transformations and RegEx validators.
* Developed for closed networks (e.g. for enterprise network without internet access)
* Oriented for modern browsers (mostly tested with Firefox 32)
* Uses JRuby, thus can be deployed on almost any Servlet container (e.g. Tomcat, WebSphere) using Warbler or started as standalone server.
* Can be easily extended with your own tools based on text input and output (using Ajax.org Ace editor or uploaded files).

TODO list (implemented and planned features):
---

- XML
  * ~~XML formatter~~
  * ~~XML escaper\unescaper~~
  * ~~XPath evaluator~~
  * ~~XML -> JSON converter~~
  * ~~XSLT transformations~~
  * ~~XSD validation~~ (with XSD definitions placed in multiple files)
- JavaScript
  * JavaScript evaluator (Rhino with configurable Java context)
  * JSON -> XML converter
- misc
  * Regexp validator (Ruby and Java syntax)
  * Unicode entity translator
  * HTTP-service stub (responses with configurable delay, status, headers and body)
  * Ping and Tracert
- Toolchains (configurable chains of transformations)
- etc.
