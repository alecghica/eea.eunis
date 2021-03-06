<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick references, show species' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.species.references.ReferencesSearchCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-references.js"></script>
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/save-criteria.js"></script>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,pick_references_show_species_location";
%>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("pick_references_show_species")%>
    </title>
<%
  // Request parameters
  String author = Utilities.formatString(request.getParameter("author"), "");
  int relationOpAuthor = Utilities.checkedStringToInt(request.getParameter("relationOpAuthor"), Utilities.OPERATOR_STARTS.intValue());
  String date = Utilities.formatString(request.getParameter("date"), "");
  String date1 = Utilities.formatString(request.getParameter("date1"), "");
  String title = Utilities.formatString(request.getParameter("title"), "");
  int relationOpTitle = Utilities.checkedStringToInt(request.getParameter("relationOpTitle"), Utilities.OPERATOR_STARTS.intValue());
  String editor = Utilities.formatString(request.getParameter("editor"), "");
  int relationOpEditor = Utilities.checkedStringToInt(request.getParameter("relationOpEditor"), Utilities.OPERATOR_STARTS.intValue());
  String publisher = Utilities.formatString(request.getParameter("publisher"), "");
  int relationOpPublisher = Utilities.checkedStringToInt(request.getParameter("relationOpPublisher"), Utilities.OPERATOR_STARTS.intValue());

%>
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
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <h1>
                  <%=cm.cmsPhrase("Pick references, show species")%>
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
                    <li>
                      <a href="species-help.jsp"><img src="images/help_icon.gif"
                             alt="<%=cm.cmsPhrase("Help information")%>"
                             title="<%=cm.cmsPhrase("Help information")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <form name="eunis" method="get" action="species-references-result.jsp" onsubmit="return validateForm();">
                  <input type="hidden" name="typeForm" value="<%=ReferencesSearchCriteria.CRITERIA_SCIENTIFIC%>" />
                  <table summary="layout" width="100%" border="0">
                    <tr>
                      <td colspan="2">
                        <%=cm.cmsPhrase("References of species selected by references<br />(ex.: all the references recorded in <strong>1978</strong>)")%>
                        <br />
                        <br />
                        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                          <tr>
                            <td>
                              <strong>
                                <%=cm.cmsPhrase("Search will provide the following information (checked fields will be displayed):")%>
                              </strong>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <input title="<%=cm.cmsPhrase("Group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                                <label for="checkbox1"><%=cm.cmsPhrase("Group")%></label>
                              <input title="<%=cm.cms("order_column")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                                <label for="checkbox2"><%=cm.cmsPhrase("Order")%></label>
                                <%=cm.cmsTitle("order_column")%>
                              <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                                <label for="checkbox3"><%=cm.cmsPhrase("Family")%></label>
                                <%=cm.cmsTitle("family")%>
                              <input title="<%=cm.cmsPhrase("Scientific name")%>" id="checkbox4" type="checkbox" name="showScientificName" value="true" checked="checked" disabled="disabled" />
                                <label for="checkbox4"><%=cm.cmsPhrase("Scientific name")%></label>
                              <input title="<%=cm.cms("vernacular_name")%>" id="checkbox5" type="checkbox" name="showVernacularName" value="true" />
                                <label for="checkbox5"><%=cm.cmsPhrase("Vernacular Name")%></label>
                                <%=cm.cmsTitle("vernacular_name")%>
                            </td>
                          </tr>
                        </table>
                        <br />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table summary="layout" width="100%" border="0">
                          <tr>
                            <td colspan="2">
                              <img alt="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" />
                              <%=cm.cmsAlt("field_included")%>
                              &nbsp;
                              <label for="author"><%=cm.cmsPhrase("Author")%></label>
                            </td>
                            <td width="17%">
                              <select id="select1" title="<%=cm.cmsPhrase("Operator")%>" name="relationOpAuthor">
                                <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpAuthor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpAuthor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpAuthor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                            </td>
                            <td width="69%">
                              <input id="author" title="<%=cm.cms("author")%>" alt="<%=cm.cms("author")%>" size="32" name="author" value="<%=author%>" />
                              <%=cm.cmsTitle("author")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','author',0)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_authors")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <%=cm.cmsAlt("list_authors")%>
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <img alt="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" />
                              <%=cm.cmsAlt("field_included")%>
                              &nbsp;
<%
  if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
  {


%>
                                <label for="date1"><%=cm.cmsPhrase("Year")%></label>
<%
  }
  else
  {
%>
                                <label for="date3"><%=cm.cmsPhrase("Year")%></label>
<%
  }
%>
                            </td>
                            <td>
                              <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="relOpDate" onchange="MM_jumpMenu('parent',this,0)">
                                <option value="species-references.jsp?between=no" <%=(request.getParameter("between")==null?"selected=\"selected\"":(request.getParameter("between").equalsIgnoreCase("yes")?"":"selected=\"selected\""))%>><%=cm.cmsPhrase("is")%></option>
                                <option value="species-references.jsp?between=yes" <%if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")){%> selected="selected"<%}%>><%=cm.cmsPhrase("Between")%></option>
                              </select>
                            </td>
                            <%
                              // If relOpDate is between
                              if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes"))
                              {
                            %>
                              <td>
                                <input id="date1" title="<%=cm.cms("begin_date")%>" alt="<%=cm.cms("begin_date")%>" size="5" name="date" value="<%=date%>" />
                                <%=cm.cmsTitle("begin_date")%>
                                &nbsp;
                                <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("publication_year")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                                <%=cm.cmsTitle("list_values_link")%>
                                <%=cm.cmsAlt("publication_year")%>
                                <%=cm.cmsPhrase("and")%>
                                <label for="date2" class="noshow"><%=cm.cms("last_date")%></label>
                                <input id="date2" title="<%=cm.cms("last_date")%>" alt="<%=cm.cms("last_date")%>" size="5" name="date1" value="<%=date1%>" />
                                <%=cm.cmsLabel("last_date")%>
                                <%=cm.cmsTitle("last_date")%>
                                &nbsp;
                                <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','date',2)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("publication_year")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                                <%=cm.cmsTitle("list_values_link")%>
                                <%=cm.cmsAlt("publication_year")%>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                              </td>
                          <%
                              }
                              else
                              {
                          %>
                                <td>
                                  <label for="date3" class="noshow"><%=cm.cms("date")%></label>
                                  <input id="date3" title="<%=cm.cms("date")%>" alt="<%=cm.cms("date")%>" size="5" name="date" value="<%=date%>" />
                                  <%=cm.cmsLabel("date")%>
                                  <%=cm.cmsTitle("date")%>
                                  <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','date',1)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("publication_year")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                                  <%=cm.cmsTitle("list_values_link")%>
                                  <%=cm.cmsAlt("publication_year")%>
                                  &nbsp;&nbsp;&nbsp;&nbsp;
                                </td>
                          <%
                              }
                              // Set value for relationOpDate hidden field
                              Integer valDate=Utilities.OPERATOR_IS;
                              if (request.getParameter("between")!=null && request.getParameter("between").equalsIgnoreCase("yes")) valDate=Utilities.OPERATOR_BETWEEN;
                          %>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <input type="hidden" name="relationOpDate" value="<%=valDate%>" />
                              <img alt="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" />
                              <%=cm.cmsAlt("field_included")%>
                              &nbsp;
                              <label for="title"><%=cm.cmsPhrase("Title")%></label>
                            </td>
                            <td>
                              <select id="select3" title="<%=cm.cmsPhrase("Operator")%>" name="relationOpTitle">
                                <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpTitle == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpTitle == Utilities.OPERATOR_CONTAINS.intValue())?"selected=\"selected\"" : ""%>><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpTitle == Utilities.OPERATOR_STARTS.intValue())?"selected=\"selected\"" : ""%>><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                            </td>
                            <td>
                              <input id="title" title="<%=cm.cms("title")%>" alt="<%=cm.cms("title")%>" size="32" name="title" value="<%=title%>" />
                              <%=cm.cmsTitle("title")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','title',0)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_title")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <%=cm.cmsAlt("list_title")%>
                              &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <img alt="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" />
                              <%=cm.cmsAlt("field_included")%>
                              &nbsp;
                              <label for="editor"><%=cm.cmsPhrase("Editor")%></label>
                            </td>
                            <td>
                              <select id="select4" title="<%=cm.cmsPhrase("Operator")%>" name="relationOpEditor">
                                <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpEditor == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpEditor == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpEditor == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                            </td>
                            <td>
                              <input id="editor" title="<%=cm.cms("editor")%>" alt="<%=cm.cms("editor")%>" size="32" name="editor" value="<%=editor%>" />
                              <%=cm.cmsTitle("editor")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','editor',0)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_editors")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <%=cm.cmsAlt("list_editors")%>
                              &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                          </tr>
                          <tr>
                            <td colspan="2">
                              <img alt="<%=cm.cms("field_included")%>" src="images/mini/field_included.gif" />
                              <%=cm.cmsAlt("field_included")%>
                              &nbsp;
                              <label for="publisher"><%=cm.cmsPhrase("Publisher")%></label>
                            </td>
                            <td>
                              <select id="select5" title="<%=cm.cmsPhrase("Operator")%>" name="relationOpPublisher">
                                <option value="<%=Utilities.OPERATOR_IS%>" <%=(relationOpPublisher == Utilities.OPERATOR_IS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("is")%></option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>" <%=(relationOpPublisher == Utilities.OPERATOR_CONTAINS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("contains")%></option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>" <%=(relationOpPublisher == Utilities.OPERATOR_STARTS.intValue()) ? "selected=\"selected\"" : ""%>><%=cm.cmsPhrase("starts with")%></option>
                              </select>
                            </td>
                            <td>
                              <input id="publisher" title="<%=cm.cms("publisher")%>" alt="<%=cm.cms("publisher")%>" size="32" name="publisher" value="<%=publisher%>" />
                              <%=cm.cmsTitle("publisher")%>
                              <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-references-choice.jsp','publisher',0)"><img height="18" style="vertical-align:middle" alt="<%=cm.cms("list_publishers")%>" src="images/helper/helper.gif" width="11" border="0" /></a>
                              <%=cm.cmsTitle("list_values_link")%>
                              <%=cm.cmsAlt("list_publishers")%>
                              &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <br />
                      </td>
                    </tr>
                    <tr>
                      <td style="text-align:right">
                        <input id="Reset" type="reset" value="<%=cm.cmsPhrase("Reset")%>" name="Reset" class="standardButton" title="<%=cm.cmsPhrase("Reset")%>" />
                        <input id="Search" type="submit" value="<%=cm.cmsPhrase("Search")%>" name="submit2" class="submitSearchButton" title="<%=cm.cmsPhrase("Search")%>" />
                      </td>
                    </tr>
                  </table>
                  </form>
                  <%
                    // Save search criteria
                    if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                    {
                  %>
                      <script type="text/javascript" language="JavaScript">
                        //<![CDATA[
                          // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
                          var source1='';
                          var source2='';
                          var database1='';
                          var database2='';
                          var database3='';
                        //]]>
                      </script>
                      <br />
                      <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-references-save-criteria.js"></script>
                      <%=cm.cmsPhrase("Save your criteria")%>:
                      <a title="<%=cm.cms("save_open_link")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-references.jsp','5','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_open_link")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
                      <%=cm.cmsTitle("save_open_link")%>
                      <%
                        // Set Vector for URL string
                        Vector show = new Vector();
                        show.addElement("showGroup");
                        show.addElement("showOrder");
                        show.addElement("showFamily");
                        show.addElement("showScientificName");
                        show.addElement("showVernacularName");
                        String pageName = "species-references.jsp";
                        String pageNameResult = "species-references-result.jsp?"+Utilities.writeURLCriteriaSave(show);
                        // Expand or not save criterias list
                        String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
                      %>
                        <jsp:include page="show-criteria-search.jsp">
                          <jsp:param name="pageName" value="<%=pageName%>" />
                          <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
                          <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
                        </jsp:include>
                  <%
                    }
                  %>

            <%=cm.br()%>
            <%=cm.cmsMsg("pick_references_show_species")%>
            <%=cm.br()%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-references.jsp" />
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
