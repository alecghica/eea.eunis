<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats module' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain,
                ro.finsiel.eunis.search.Utilities" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <%
    WebContentManagement cm = SessionManager.getWebContent();
    String eeaHome = application.getInitParameter( "EEA_HOME" );
    String btrail = "eea#" + eeaHome + ",home#index.jsp,habitat_types";
    int tab = Utilities.checkedStringToInt( request.getParameter( "tab" ), 0 );
    String []tabs = { cm.cms("easy_search"), cm.cms("advanced_search"), cm.cms("help") };
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitat_type_search")%>
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
                  <jsp:param name="location" value="<%=btrail%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <div id="loading">
                <%=cm.cms("loading_data")%>
                </div>
                  <h1 class="documentFirstHeading">
                    <%=cm.cmsPhrase("Habitat types search")%>
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
                  <div class="documentDescription">
                    <%=cm.cmsPhrase("Find information about habitat types of interest for biodiversity and nature protection")%>
                  </div>

                <div id="qs" align="center" style="padding-left : 10px; width : 90%; vertical-align : middle;">
                  <form name="quick_search" action="habitats-names-result.jsp" method="post" onsubmit="javascript:if(trim(document.quick_search.searchString.value) == '' || trim(document.quick_search.searchString.value) == 'Enter habitat name here...') {alert('Before searching, please type a few letters from habitat name.');return false;} else return true; ">
                    <input type="hidden" name="showLevel" value="true" />
                    <input type="hidden" name="showCode" value="true" />
                    <input type="hidden" name="showScientificName" value="true" />
                    <input type="hidden" name="showVernacularName" value="true" />
                    <input type="hidden" name="showOtherInfo" value="true" />
                    <input type="hidden" name="database" value="<%=NamesDomain.SEARCH_BOTH%>" />
                    <input type="hidden" name="useScientific" value="true" />
                    <input type="hidden" name="useVernacular" value="true" />
                    <input type="hidden" name="fuzzySearch" value="true" />
                    <input type="hidden" name="relationOp" value="<%=Utilities.OPERATOR_STARTS%>" />
                    <label for="searchString"><%=cm.cmsPhrase("Search habitat types with names starting with:")%></label>
                    <input id="searchString" type="text"
                           size="30" name="searchString"
                           value="<%=cm.cms("enter_habitat_name_here")%>"
                           onfocus="if(this.value=='<%=cm.cms("enter_habitat_name_here")%>')this.value='';"
                           onblur="if(this.value=='')this.value='<%=cm.cms("enter_habitat_name_here")%>';" />
                    <%=cm.cmsTitle("habitat_to_search_for")%>
                    <%=cm.cmsInput("enter_habitat_name_here")%>
                    <input type="submit"
                           value="<%=cm.cmsPhrase("Search")%>"
                           name="Submit"
                           id="Submit"
                           class="submitSearchButton"
                           title="Search" />
                    <a href="fuzzy-search-help.jsp" title="<%=cm.cms("help_fuzzy_search")%>"><img alt="<%=cm.cms("help_fuzzy_search")%>" title="<%=cm.cms("help_fuzzy_search")%>" src="images/mini/help.jpg" border="0" style="vertical-align:middle" /></a>
                    <%=cm.cmsTitle("help_fuzzy_search")%>
                  </form>
                <br />
                </div>
                <div id="tabbedmenu">
                  <ul>
                <%
                  String currentTab = "";
                  for ( int i = 0; i < tabs.length; i++ )
                  {
                    currentTab = "";
                    if ( tab == i ) currentTab = " id=\"currenttab\"";
                %>
                      <li<%=currentTab%>>
                        <a title="<%=cm.cms("show")%> <%=tabs[i]%>" href="habitats.jsp?tab=<%=i%>"><%=tabs[i]%></a>
                        <%=cm.cmsTitle("show")%>
                      </li>
                <%
                    }
                %>
                      </ul>
                    </div>
                    <br clear="all" />
                    <br />
                <%
                  if ( tab == 0 )
                  {
                %>
                <table summary="<%=cm.cms("easy_searches")%>" class="datatable fullwidth">
                  <caption>
                    <%=cm.cmsPhrase("A set of predefined functions to search the database") %>
                  </caption>
                  <thead>
                    <tr>
                      <th width="40%" style="white-space:nowrap">
                        <%=cm.cmsPhrase("Links to easy searches")%>
                      </th>
                      <th width="60%">
                        <%=cm.cmsPhrase("Description")%>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td width="40%" style="white-space:nowrap">
                        <img alt="<%=cm.cms("names_and_descriptions")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("names_and_descriptions")%>
                        <a title="<%=cm.cms("habitats_main_namesDesc")%>" href="habitats-names.jsp"><strong><%=cm.cmsPhrase("Names and Descriptions")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_namesDesc")%>
                      </td>
                      <td width="60%">
                        <%=cm.cmsPhrase("Search habitat types by name or description")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("legal_instruments")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("legal_instruments")%>
                        <a title="<%=cm.cms("habitats_main_legalDesc")%>"  href="habitats-legal.jsp"><strong><%=cm.cmsPhrase("Legal Instruments")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_legalDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Search EUNIS habitat types under legal designation at European level")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("country_biogeographic_region_location")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("country_biogeographic_region_location")%>
                        <a title="<%=cm.cms("habitats_main_countryDesc")%>"  href="habitats-country.jsp"><strong><%=cm.cmsPhrase("Country/Biogeographic region")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_countryDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find habitat types located within a country and/or biogeographic region")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("code_classifications")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("code_classifications")%>
                        <a title="<%=cm.cms("habitats_main_codeDesc")%>"  href="habitats-code.jsp"><strong><%=cm.cmsPhrase("Code/Classifications")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_codeDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find habitat types by their relations with one of the linked classifications")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("pick_habitat_types_show_species")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_habitat_types_show_species")%>
                        <a title="<%=cm.cms("habitats_main_showSpeciesDesc")%>"  href="species-habitats.jsp"><strong><%=cm.cmsPhrase("Pick habitat types, show species")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_showSpeciesDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find species characterising a specific habitat type")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("pick_habitat_types_show_sites")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_habitat_types_show_sites")%>
                        <a title="<%=cm.cms("habitats_main_showSitesDesc")%>"  href="sites-habitats.jsp"><strong><%=cm.cmsPhrase("Pick habitat types, show sites")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_showSitesDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find sites containing a particular habitat type")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("habitats_main_showReferences")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_showReferences")%>
                        <a title="<%=cm.cms("habitats_main_showReferencesDesc")%>"  href="habitats-books.jsp"><strong><%=cm.cmsPhrase("Pick habitat types, show references")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_showReferencesDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find books, articles which refer to a habitat type")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("pick_references_show_habitat_types")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("pick_references_show_habitat_types")%>
                        <a title="<%=cm.cms("habitats_main_showHabitatsDesc")%>"  href="habitats-references.jsp"><strong><%=cm.cmsPhrase("Pick references, show habitat types")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_showHabitatsDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Find habitat types referred by books, articles etc.")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("habitats_main_key")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_key")%>
                        <a title="<%=cm.cms("habitats_main_keyDesc")%>"  href="habitats-key.jsp"><strong><%=cm.cmsPhrase("Key navigation")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_keyDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Identify a habitat type following questions and graphical schemas")%>
                      </td>
                    </tr>
                    <tr class="zebraeven">
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("habitats_main_EUNIShierarchy")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_EUNIShierarchy")%>
                        <a title="<%=cm.cms("habitats_main_EUNIShierarchyDesc")%>"  href="habitats-code-browser.jsp"><strong><%=cm.cmsPhrase("EUNIS habitat types hierarchical view")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_EUNIShierarchyDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Hierarchical visualisation of EUNIS habitat types classification")%>
                      </td>
                    </tr>
                    <tr>
                      <td style="white-space:nowrap">
                        <img alt="<%=cm.cms("habitats_main_ANNEXhierarchy")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_ANNEXhierarchy")%>
                        <a title="<%=cm.cms("habitats_main_ANNEXhierarchyDesc")%>"  href="habitats-annex1-browser.jsp"><strong><%=cm.cmsPhrase("ANNEX I habitat types hierarchical view")%></strong></a>
                        <%=cm.cmsTitle("habitats_main_ANNEXhierarchyDesc")%>
                      </td>
                      <td>
                        <%=cm.cmsPhrase("Hierarchical visualisation of ANNEX I habitat types classification")%>
                      </td>
                    </tr>
                  </tbody>
                </table>
                <%
                  }
                  if ( tab == 1 )
                  {
                %>
                  <table summary="<%=cm.cms("advanced_searches")%>" class="datatable fullwidth">
                    <caption>
                      <%=cm.cmsPhrase("Search habitat type information using more complex filtering capabilities") %>
                    </caption>
                    <thead>
                      <tr>
                        <th width="40%" style="white-space:nowrap">
                          <%=cm.cmsPhrase("Links to advanced searches")%>
                        </th>
                        <th width="60%">
                          <%=cm.cmsPhrase("Description")%>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td width="40%" style="white-space:nowrap">
                          <img alt="" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" />
                          <a title="<%=cm.cms("habitats_main_advSearchSearchDesc")%>"  href="habitats-advanced.jsp?natureobject=Habitat"><strong><%=cm.cmsPhrase("Advanced Search")%></strong></a>
                          <%=cm.cmsTitle("habitats_main_advSearchSearchDesc")%>
                        </td>
                        <td width="60%">
                          <%=cm.cmsPhrase("Search habitat types information using more complex filtering capabilities")%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td style="white-space:nowrap">
                          <img alt="<%=cm.cms("how_to_use_advanced_search")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("how_to_use_advanced_search")%>
                          <a title="<%=cm.cms("habitats_main_advSearchHelpDesc")%>"  href="advanced-help.jsp"><strong><%=cm.cmsPhrase("How to use Advanced search")%></strong></a>
                          <%=cm.cmsTitle("habitats_main_advSearchHelpDesc")%>
                        </td>
                        <td>
                          <%=cm.cmsPhrase("Help on habitat types <strong>Advanced Search</strong>")%>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                <%
                  }
                  if ( tab == 2 )
                  {
                %>
                  <table summary="Help" class="datatable fullwidth">
                    <caption>
                      <%=cm.cmsPhrase("General information on EUNIS application") %>
                    </caption>
                    <thead>
                      <tr>
                        <th width="40%" style="white-space:nowrap">
                          <%=cm.cmsPhrase("Links to online help")%>
                        </th>
                        <th width="60%">
                          <%=cm.cmsPhrase("Description")%>
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td width="40%" style="white-space:nowrap">
                          <img alt="<%=cm.cms("habitats_main_easyHelp")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("habitats_main_easyHelp")%>
                          <a title="<%=cm.cms("habitats_main_easyHelpDesc")%>"  href="easy-help.jsp"><strong><%=cm.cmsPhrase("How to use Easy searches")%></strong></a>
                          <%=cm.cmsTitle("habitats_main_easyHelpDesc")%>
                        </td>
                        <td width="60%">
                          <%=cm.cmsPhrase("Help on habitat types <strong>Easy Searches</strong>")%>
                        </td>
                      </tr>
                      <tr class="zebraeven">
                        <td style="white-space:nowrap">
                          <img alt="<%=cm.cms("glossary")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("glossary")%>
                          <a title="<%=cm.cms("habitats_main_glossaryDesc")%>"  href="glossary.jsp?module=habitat"><strong><%=cm.cmsPhrase("Glossary")%></strong></a>
                          <%=cm.cmsTitle("habitats_main_glossaryDesc")%>
                        </td>
                        <td>
                          <%=cm.cmsPhrase("Glossary of terms used in EUNIS Database habitat types module")%>
                        </td>
                      </tr>
                      <tr>
                        <td style="white-space:nowrap">
                          <img alt="<%=cm.cms("how_to_use")%>" src="images/mini/bulletb.gif" width="6" height="6" style="vertical-align:middle" /><%=cm.cmsTitle("how_to_use")%>
                          <a title="<%=cm.cms("habitats_main_howToDesc")%>"  href="habitats-help.jsp"><strong><%=cm.cmsPhrase("How to use")%></strong></a>
                          <%=cm.cmsTitle("habitats_main_howToDesc")%>
                        </td>
                        <td>
                          <%=cm.cmsPhrase("Help on EUNIS Database habitat types module search tools")%>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                <%
                  }
                %>
                <%=cm.br()%>
                <%=cm.cmsMsg("habitat_type_search")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("easy_searches")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("advanced_searches")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("easy_search")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("advanced_search")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("links_and_downloads")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("help")%>
                <%=cm.br()%>
                <%=cm.cmsMsg("loading_data")%>
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
                <jsp:param name="page_name" value="habitats.jsp" />
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
    <script language="javascript" type="text/javascript">
    try
      {
        var ctrl_loading = document.getElementById("loading");
        ctrl_loading.style.display = "none";
      }
      catch ( e )
      {
      }
    </script>
  </body>
</html>
