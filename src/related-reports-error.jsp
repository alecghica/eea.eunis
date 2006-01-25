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
  WebContentManagement cm = SessionManager.getWebContent();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("related_reports_error_page_title")%>
    </title>
  </head>
  <body>
    <h1>
      <%=cm.cmsText("related_reports_error_title")%>
    </h1>
    <br />
    <br />
    <br />
      <%=cm.cmsText("related_reports_error_description")%>
    <br />
    <strong>
      <a href="javascript:history.go(-1);"><%=cm.cmsText("related_reports_error_back")%></a>.
    </strong>
<%
  if( !message.equalsIgnoreCase( "" ) )
  {
%>
    <%=message%>
<%
  }
%>
    <form action="">
      <input type="button" onClick="javascript:window.close();" value="<%=cm.cms("close_window_label")%>" title="<%=cm.cms("close_window_label")%>" id="button2" name="button" class="inputTextField" />
      <%=cm.cmsTitle("close_window_label")%>
      <%=cm.cmsInput("close_window_label")%>
    </form>
    <%=cm.cmsMsg("related_reports_error_page_title")%>
  </body>
</html>