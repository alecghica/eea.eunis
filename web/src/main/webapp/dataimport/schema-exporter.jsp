<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : News page
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,ro.finsiel.eunis.utilities.SQLUtilities,java.util.*"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
<%
  String domainName = application.getInitParameter( "DOMAIN_NAME" );
%>
  <base href="<%=domainName%>/"/>
    <jsp:include page="../header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,data import#dataimport/index.jsp,schema export";
%>
    <title>
      Schema Export
    </title>
  </head>
  <body>
    <div id="visual-portal-wrapper">
      <jsp:include page="../header.jsp" />
      <!-- The wrapper div. It contains the three columns. -->
      <div id="portal-columns" class="visualColumnHideTwo">
        <!-- start of the main and left columns -->
        <div id="visual-column-wrapper">
          <!-- start of main content block -->
          <div id="portal-column-content">
            <div id="content">
              <div class="documentContent" id="region-content">
              	<jsp:include page="../header-dynamic.jsp">
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <h1>
                  Schema Export
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
<!-- MAIN CONTENT -->
                <%
                if( SessionManager.isAuthenticated() && SessionManager.isImportExportData_RIGHT() ){
                %>
	                <p class="documentDescription">
	                The purpose of this page is to create XML schema from EUNIS database table structure.
	                </p>
	                <form name="eunis" method="get" action="<%=domainName%>/schemaexporter">
	                	<label for="table">Table</label>
		                <select id="table" name="table" title="Table names">
		                	<option value=""></option>
		                <%
		                	String SQL_DRV = application.getInitParameter("JDBC_DRV");
		                    String SQL_URL = application.getInitParameter("JDBC_URL");
		                    String SQL_USR = application.getInitParameter("JDBC_USR");
		                    String SQL_PWD = application.getInitParameter("JDBC_PWD");
		
		                    SQLUtilities sqlc = new SQLUtilities();
		                    sqlc.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
		                    
		                	List<String> tableNames = sqlc.getAllChm62edtTableNames();
		                	for(Iterator it = tableNames.iterator(); it.hasNext();){
			                	String tableName = (String) it.next();%>
			                	<option value="<%=tableName%>"><%=tableName%></option>
			                	<%
		                	}
		                %>
		                </select>
		                <input type="submit" name="btn" value="Create"/>
		            </form>
		            <%
		            List<String> errors = (List<String>)request.getSession().getAttribute("errors");
		            if(errors != null && errors.size() > 0){%>
		            	<h2><%=errors.size()%> errors found:</h2>
		            	<ul>
		            	<%
			         	for(int i = 0 ; i<errors.size() ; i++) {
				         	String error = errors.get(i);
			         		%>
			         		<li><%=error%></li>
			         		<%
				        }
				        %>
				        </ul>
				        <%
				        request.getSession().removeAttribute("errors");
		            }
				} else {
	            	%>
	            		<div class="error-msg">
		                <%=cm.cmsPhrase("You must be authenticated and have the proper right to access this page.")%>
		              </div>
	            	<%	
            	}
                %>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="../inc_column_left.jsp">
                <jsp:param name="page_name" value="news.jsp" />
              </jsp:include>
            </div>
          </div>
          <!-- end of the left (by default at least) column -->
        </div>
        <!-- end of the main and left columns -->
        <div class="visualClear"><!-- --></div>
      </div>
      <!-- end column wrapper -->
      <jsp:include page="../footer-static.jsp" />
    </div>
  </body>
</html>
