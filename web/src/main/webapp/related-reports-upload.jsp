<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports upload page' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement" %><%@ page import="ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
  int maxSize = Utilities.checkedStringToInt( application.getInitParameter( "UPLOAD_FILE_MAX_SIZE" ), 10485760 ) / 1048576;
%>
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("upload_manager")%>
  </title>
  <script language="JavaScript" type="text/javascript">
  //<![CDATA[
    function validateForm() {
      if (document.uploadFile.filename.value == "")
      {
        alert("<%=cm.cms("related_reports_upload_empty")%>.");
        return false;
      }
      if (document.uploadFile.description.value == "" ||
          document.uploadFile.description.value == "<%=cm.cms("related_reports_upload_description_value")%>") {
          alert("<%=cm.cms("related_reports_upload_validate_description")%>.");
          return false;
      }
      return true;
    }
  //]]>
  </script>
</head>

<body bgcolor="#ffffff">
<%
  if(SessionManager.isAuthenticated() && SessionManager.isUpload_reports_RIGHT()) {
%>
<form action="<%=application.getInitParameter("DOMAIN_NAME")%>/fileupload" method="post" enctype="multipart/form-data" name="uploadFile" onsubmit="return validateForm();">
  <input type="hidden" name="uploadType" value="file" /><br />

  <label for="filename"><%=cm.cmsPhrase("File to upload")%>:</label><br />
  <input title="<%=cm.cms("related_reports_upload_filetoupload_title")%>" id="filename" name="filename" type="file" size="50" /><br />
  <%=cm.cmsTitle("related_reports_upload_filetoupload_title")%>
  <%=cm.cmsPhrase("Press <strong>Browse</strong> to select a file from your computer or <strong>Close</strong> to finish.")%>
  <br />
  <%=cm.cmsPhrase("Please notice that file size is limited to")%> <strong><%=maxSize%> MB</strong>.
  <br />
  <p>
    <label for="description"><%=cm.cmsPhrase("Document description")%>:</label>
    <br />
    <textarea title="<%=cm.cms("document_description")%>" id="description" name="description" cols="60" rows="5"><%=cm.cms("related_reports_upload_description_value")%></textarea>
    <%=cm.cmsTitle("document_description")%>
    <%=cm.cmsInput("related_reports_upload_description_value")%>
  </p>
  <p>
    <input title="<%=cm.cmsPhrase("Reset values")%>" type="reset" name="Reset" id="Reset" value="<%=cm.cmsPhrase("Reset")%>" class="standardButton" />

    <input title="<%=cm.cms("upload_document")%>" type="submit" name="Submit" id="Submit" value="<%=cm.cms("upload")%>" class="submitSearchButton" />
    <%=cm.cmsTitle("upload_document")%>
    <%=cm.cmsInput("upload")%>

    <input type="button" onclick="javascript:window.close();" value="<%=cm.cmsPhrase("Close window")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
  </p>
</form>
<%
  String message = request.getParameter("message");
  if(null != message)
  {
%>
<div class="system-msg">
  <%=message%>
</div>
<%
  }
%>
  <strong>
    <%=cm.cmsPhrase("Uploaded documents are not made available for download, until they are approved by an EUNIS Database administrator")%>.
  </strong>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
  window.opener.location.href='related-reports.jsp';
//]]>
</script>
<%
}
else
{
%>
  <%=cm.cmsPhrase("You must be logged in and have the proper rights in order to access this page")%>.
  <br />
  <form action="">
    <input type="button" onclick="javascript:window.close();" value="<%=cm.cmsPhrase("Close window")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button1" name="button" class="standardButton" />
  </form>
<%
  }
%>
    <%=cm.cmsMsg("upload_manager")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_empty")%>
    <%=cm.br()%>
    <%=cm.cmsMsg("related_reports_upload_validate_description")%>
  </body>
</html>
