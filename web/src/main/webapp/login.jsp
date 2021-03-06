<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Login page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.Utilities"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,login";
  boolean success = false;
  String username = request.getParameter( "username" );
  String cmd = Utilities.formatString( request.getParameter( "cmd" ), "" );
  String ref = request.getParameter( "ref" );
  // If cmd is login.
  if ( cmd.equalsIgnoreCase( "login" ) )
  {
    SessionManager.logout();
    try
    {
      String password = request.getParameter( "password" );
      success = ( null != username && null != password ) && SessionManager.login( username, password, request );
      SessionManager.setCurrentLanguage( SessionManager.getUserPrefs().getLang() );
    }
    catch ( Exception e )
    {
      e.printStackTrace();
      success = false;
    }
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>" lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cmsPhrase("Login into EUNIS Database")%>
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
                <jsp:include page="header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
<!-- MAIN CONTENT -->
                <h1>
                  <%=cm.cmsPhrase("EUNIS Database Login")%>
                </h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
                            alt="<%=cm.cmsPhrase("Print this page")%>"
                            title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
                             alt="<%=cm.cmsPhrase("Toggle full screen mode")%>"
                             title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
          <%
            if ( !success )
            {
              if ( cmd.equalsIgnoreCase( "login" ) && !success )
              {
          %>
              <div class="error-msg">
                  <%=cm.cmsPhrase("Invalid login name or password")%>
              </div>
          <%
              }
          %>
                  <form name="login" method="post" action="login.jsp" style="text-align:center; width : 100%">
                    <input type="hidden" name="cmd" value="login" />
          <%
                if( ref != null )
                {
          %>
                    <input type="hidden" name="ref" value="<%=ref%>" />
          <%
                }
          %>
                    <label for="username"><%=cm.cms("login_username_label")%>:</label>
                    <input title="<%=cm.cms("login_username_title")%>" type="text" id="username" name="username" value="<%=(null != username) ? username : ""%>" />
                    <%=cm.cmsTitle("login_username_title")%>
                    <%=cm.cmsLabel("login_username_label")%>
                    <br />
                    <label for="password"><%=cm.cms("password")%>:</label>
                    <input title="<%=cm.cms("login_password_title")%>" type="password" id="password" name="password" />
                    <%=cm.cmsTitle("login_password_title")%>
                    <%=cm.cmsLabel("password")%>
                    <br />
                    <br />
                    <input class="submitSearchButton" title="<%=cm.cms("login_submit_title")%>" type="submit" id="submit" name="Submit" value="<%=cm.cms("login")%>" />
                    <%=cm.cmsTitle("login_submit_title")%>
                    <%=cm.cmsInput("login")%>
                  </form>
          <%
            }
            else
            {
          %>
             <div class="system-msg">
              <%=cm.cmsPhrase("You successfully logged in as")%>
              <strong><%=SessionManager.getUsername()%></strong>.
							<ul>
              <li><a href="services.jsp"><%=cm.cmsPhrase("Services-page")%></a></li>
							</ul>
             </div>
          <%
            }
          %>
              <%=cm.cmsText("habitats_login-help_01")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="login.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="footer-static.jsp" />
    </div>
  </body>
</html>
