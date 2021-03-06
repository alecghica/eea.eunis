<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Copyright page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.jrfTables.Chm62edtReferencesDomain,
                 java.util.Iterator,
                 java.util.List,
                 ro.finsiel.eunis.jrfTables.Chm62edtReferencesPersist,
                 ro.finsiel.eunis.WebContentManagement, ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,copyright_and_disclaimer_title";
%>
  <title><%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cmsPhrase("Copyright and disclaimer")%>
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
		<h1><%=cm.cmsPhrase("Copyright, disclaimer and privacy statement notice")%></h1>
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
                <%=cm.cmsText("generic_copyright_01")%>
                <table class="datatable" style="table-layout:fixed">
		  <col style="width:40%"/>
		  <col style="width:50%"/>
		  <col style="width:10%"/>
                  <thead>
                    <tr>
                      <th>
                        <%=cm.cmsPhrase("Author")%>
                      </th>
                      <th>
                        <%=cm.cmsPhrase("Title")%>
                      </th>
                      <th style="text-align: center;">
                        <%=cm.cmsPhrase("Publication date")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  try {
                    Chm62edtReferencesDomain nd = new Chm62edtReferencesDomain();
                    // List of all 'REFERENCES'
                    String sSQL = "SELECT `ID_DC`,";
                    sSQL += " `SOURCE`,";
                    sSQL += " CONCAT(`CREATED`),";
                    sSQL += " `TITLE`,";
                    sSQL += " `ALTERNATIVE`,";
                    sSQL += " `EDITOR`,";
                    sSQL += " `JOURNAL_TITLE`,";
                    sSQL += " `BOOK_TITLE`,";
                    sSQL += " `JOURNAL_ISSUE`,";
                    sSQL += " `PUBLISHER`,";
                    sSQL += " `ISBN`,";
                    sSQL += " `URL`";
                    sSQL += " FROM  `DC_INDEX`";
                    sSQL += " WHERE `COMMENT` = 'REFERENCES'";
                    sSQL += " ORDER BY `SOURCE` ASC";

                    List list = nd.findCustom(sSQL);

                    if(null != list && list.size() > 0) {
                      Iterator it = list.iterator();
                      int cnt = 0;
                      while(it.hasNext())
                      {
                        Chm62edtReferencesPersist nl = (Chm62edtReferencesPersist) it.next();
                        if(!nl.getAuthor().equalsIgnoreCase("No additional references") && !nl.getAuthor().equalsIgnoreCase("--"))
                        {
                          String cssClass = cnt++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                %>
                <tr<%=cssClass%>>
                  <td id="A<%=cnt%>1">
					<a href="references/<%=nl.getIdReference()%>"><%=Utilities.treatURLSpecialCharacters( nl.getAuthor() )%></a>
                  </td>
                  <td>
                    <%=Utilities.treatURLSpecialCharacters( nl.getTitle() )%>
                  </td>
                  <td style="text-align: center;">
                    <%=nl.getPublicationDate()%>
                  </td>
                </tr>
                <%
                        }
                      }
                    }
                  } catch(Exception e) {
                    e.printStackTrace();
                  }
                %>
                </tbody>
              </table>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="copyright.jsp"/>
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
