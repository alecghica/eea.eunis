<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Related reports error page' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String message = Utilities.formatString( request.getParameter("status"), "" );
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
  </head>
  <body>
    <h1>
      <%=cm.cmsPhrase("Related reports")%>
    </h1>

    <div class="error-msg">
      <%=cm.cmsPhrase("There was an error while trying to upload the document.")%>
    <br />
    <strong>
      <a href="javascript:history.go(-1);"><%=cm.cmsPhrase("Back")%></a>.
    </strong>
		</div>
<%
  if( !message.equalsIgnoreCase( "" ) )
  {
%>
    <%=message%>
<%
  }
%>
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cmsPhrase("Close window")%>" title="<%=cm.cmsPhrase("Close window")%>" id="button2" name="button" class="standardButton" />
    </form>
    <%=cm.cmsMsg("upload_manager")%>
  </body>
</html>
