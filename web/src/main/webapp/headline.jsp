<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Headline page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.utilities.SQLUtilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,services#services.jsp,headline";
  WebContentManagement cm = SessionManager.getWebContent();
  /*
  System.out.println("==============================================");
  System.out.println("Input parameters:");
  */
  String insert = request.getParameter("insert");
  String delete = request.getParameter("delete");
  String deleteall = request.getParameter("deleteall");
  String headline = request.getParameter("headline");
  String start_date = request.getParameter("start_date");
  String end_date = request.getParameter("end_date");
  /*
  System.out.println("insert = " + insert);
  System.out.println("delete = " + delete);
  System.out.println("deleteall = " + deleteall);
  System.out.println("headline = " + headline);
  System.out.println("start_date = " + start_date);
  System.out.println("end_date = " + end_date);

  System.out.println("==============================================");
  */
  try
  {

  String SQL_DRV = application.getInitParameter("JDBC_DRV");
  String SQL_URL = application.getInitParameter("JDBC_URL");
  String SQL_USR = application.getInitParameter("JDBC_USR");
  String SQL_PWD = application.getInitParameter("JDBC_PWD");

  if(headline == null) {headline=""; }
  if(start_date == null) {start_date=""; }
  if(end_date == null) {end_date=""; }

  SQLUtilities sqlc = new SQLUtilities();
  sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

  if(insert == null && delete == null && deleteall == null) {
    String sContent = "select content from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    headline = sqlc.ExecuteSQL(sContent);
    //System.out.println("headline = " + headline);
    String sStartDate = "select start_date from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    start_date = sqlc.ExecuteSQL(sStartDate);
    //System.out.println("start_date = " + start_date);
    String sEndDate = "select end_date from eunis_headlines where NOW() between start_date and end_date order by record_date desc";
    end_date = sqlc.ExecuteSQL(sEndDate);
    //System.out.println("end_date = " + end_date);
  } else {
    if(null != insert && insert.equalsIgnoreCase(cm.cms( "headline_insert" ) )) {
      String sContent = "insert into eunis_headlines(content,start_date,end_date) values('" + headline + "','" + start_date + "','" + end_date + "')";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);
      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }

    if(null != delete && delete.equalsIgnoreCase("delete"))
    {
      String sContent = "delete from eunis_headlines where content='" + headline + "' and start_date='" + start_date + "' and end_date='" + end_date + "'";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);
%>
      <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        alert('<%=cm.cms("headline_deleted")%>');
      //]]>
      </script>
      <%

      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }

    if(null != deleteall && deleteall.equalsIgnoreCase("delete all")) {
      String sContent = "delete from eunis_headlines";
      //System.out.println("sContent = " + sContent);
      sqlc.ExecuteDirectSQL(sContent);

      %>
      <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        alert('<%=cm.cms("headlines_deleted_all")%>');
      //]]>
      </script>
      <%

      String URL = "headline.jsp";
      response.sendRedirect(URL);
      return;
    }
  }
        }
        catch( Exception e ) {e.printStackTrace( ); }
  boolean authorised = SessionManager.isAuthenticated() && SessionManager.isContent_management_RIGHT();
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cmsPhrase("Edit Headlines")%>
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
                <h1><%=cm.cmsPhrase("Edit Headlines")%></h1>
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
<!-- MAIN CONTENT -->
          <%
            // If user is authentificated and has this right
            if(!authorised)
            {
          %>
                <div class="error-msg">
                  <%=cm.cmsPhrase("You can't do this because you are not authentificated or you don't have enough rights!")%>
                <a href="login.jsp" title="Login"><%=cm.cmsPhrase("EUNIS Login")%></a>
                </div>
          <%
            }
            else
            {
          %>
                <br />
                <form method="post" name="webcontent" action="headline.jsp">
                  <label for="headline">
                    <%=cm.cms("current_headline_label")%>:
                  </label>
                  <br />
                  <textarea rows="10" cols="80" name="headline" id="headline"><%=headline%></textarea>
                  <%=cm.cmsLabel("current_headline_label")%>
                  <br />
                  <br />
                  <label for="start_date">
                    <%=cm.cms("headline_start_date")%>:
                  </label>
                  <input type="text" name="start_date" id="start_date" size="12" value="<%=start_date%>" title="<%=cm.cms("headline_start_date")%>" />
                  <%=cm.cmsLabel("headline_start_date")%>
                  (yyyy-MM-dd)
                  <br />
                  <br />
                  <label for="end_date">
                    <%=cm.cms("headline_end_date")%>:
                  </label>
                  <input type="text" name="end_date" id="end_date" size="12" value="<%=end_date%>" title="<%=cm.cms("headline_end_date")%>" />
                  <%=cm.cmsLabel("headline_end_date")%>
                  (yyyy-MM-dd)
                  <br />
                  <br />
                  <br />
                  <input class="submitSearchButton" type="submit" value="<%=cm.cms("headline_insert")%>" id="insert" name="insert" title="<%=cm.cms("headline_insert_label")%>" />&nbsp;&nbsp;
                  <%=cm.cmsInput("headline_insert")%>

                  <input class="submitSearchButton" type="submit" value="<%=cm.cms("delete")%>" id="delete" name="delete" title="<%=cm.cms("delete")%>" />&nbsp;&nbsp;
                  <%=cm.cmsInput("delete")%>

                  <input class="submitSearchButton" type="submit" value="<%=cm.cms("delete_all")%>" id="deleteall" name="deleteall" title="<%=cm.cms("delete_all")%>" />
                  <%=cm.cmsInput("delete_all")%>
                </form>
          <%
            }
          %>
                <%=cm.br()%>
                <%=cm.cmsMsg("headline_updated")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("headline_deleted")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("headlines_deleted_all")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="headline.jsp"/>
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
