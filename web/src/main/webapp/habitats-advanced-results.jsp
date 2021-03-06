<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats advanced search' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.advanced.AdvancedSortCriteria,
                 ro.finsiel.eunis.search.habitats.advanced.DictionaryPaginator,
                 java.util.Iterator" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  AbstractPaginator paginator;
  // Database where to search. Possible values are: Species, Habitats or Sites
  //String searchedDatabase = formBean.getSearchedNatureObject();
  paginator = new DictionaryPaginator(new DictionaryDomain(request.getSession().getId()));
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  int resultsCount = paginator.countResults();
  final String pageName = "habitats-advanced-results.jsp";
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = paginator.getPage(currentPage);
  Iterator it = (null != results) ? results.iterator() : new Vector().iterator();

  Vector columnsDisplayed = formBean.parseShowColumns();
  boolean showLevel = (columnsDisplayed.contains("showLevel"));
  boolean showEUNISCode = (columnsDisplayed.contains("showEUNISCode"));
  boolean showANNEXCode = (columnsDisplayed.contains("showANNEXCode"));
  boolean showScientificName = (columnsDisplayed.contains("showScientificName"));
  boolean showEnglishName = (columnsDisplayed.contains("showEnglishName"));
//  boolean showLegalInstruments = (columnsDisplayed.contains("showLegalInstruments"));
//  boolean showCountry = (columnsDisplayed.contains("showCountry"));
//  boolean showRegion = (columnsDisplayed.contains("showRegion"));
//  boolean showReferences = (columnsDisplayed.contains("showReferences"));
//  boolean showDiagram = (columnsDisplayed.contains("showDiagram"));
  boolean showPriority = (columnsDisplayed.contains("showPriority"));
  boolean showDescription = (columnsDisplayed.contains("showDescription"));

  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-advanced.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,habitat_types#habitats.jsp,advanced_search#habitats-advanced.jsp,results";
  if (results.isEmpty())
  {
%>
    <jsp:forward page="emptyresults.jsp">
      <jsp:param name="location" value="<%=location%>" />
    </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-result.js"></script>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_advanced-results_title")%>
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
                  <jsp:param name="location" value="<%=location%>" />
                  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
                </jsp:include>
                <a name="documentContent"></a>
                <h1><%=cm.cmsPhrase("Habitats advanced search results")%></h1>
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
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                <td>
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("You searched for habitat types using advanced search criteria")%>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=cm.cmsPhrase("Criteria combination used")%>
                      :<%=SessionManager.getExplainedcriteria()%>
                      , <%=cm.cmsPhrase("where")%>:
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <%=SessionManager.getListcriteria()%>
                    </td>
                  </tr>
                </table>
                  <br />
                  <%=cm.cmsPhrase("Results found")%>:&nbsp;<strong><%=resultsCount%></strong>
                  <br />
                  <%// Prepare parameters for pagesize.jsp
                    Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                    pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                    pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                    /*   to page '0' aka first page. */
                  %>
                  <jsp:include page="pagesize.jsp">
                    <jsp:param name="guid" value="<%=guid%>" />
                    <jsp:param name="pageName" value="<%=pageName%>" />
                    <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
                    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
                  </jsp:include>
                  <%
                    // Prepare the form parameters.
                    Vector filterSearch = new Vector();
                    filterSearch.addElement("sort");
                    filterSearch.addElement("ascendency");
                    filterSearch.addElement("pageSize");
                  %>
                  <br />
                  <%
                    Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                    navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                    navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                    navigatorFormFields.addElement("ascendency");
                  %>
                  <jsp:include page="navigator.jsp">
                    <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                    <jsp:param name="pageName" value="<%=pageName%>" />
                    <jsp:param name="guid" value="<%=guid%>" />
                    <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                    <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                    <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                  </jsp:include>
                <%// Compute the sort criteria
                  Vector sortURLFields = new Vector();      /* Used for sorting */
                  sortURLFields.addElement("pageSize");
                  String urlSortString = formBean.toURLParam(sortURLFields);
                  AbstractSortCriteria sortLevel = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_LEVEL);
                  AbstractSortCriteria sortEunisCode = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_EUNIS_CODE);
                  AbstractSortCriteria sortAnnexCode = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ANNEX_CODE);
                  AbstractSortCriteria sortScientificName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_SCIENTIFIC_NAME);
                  AbstractSortCriteria sortEnglishName = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_ENGLISH_NAME);
                  AbstractSortCriteria sortPriority = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_PRIORITY);
                  AbstractSortCriteria sortDescription = formBean.lookupSortCriteria(AdvancedSortCriteria.SORT_DESCRIPTION);

                  // Expand/Collapse english names
                  Vector expand = new Vector();
                  expand.addElement("sort");
                  expand.addElement("ascendency");
                  expand.addElement("pageSize");
                  expand.addElement("currentPage");
                  String expandURL = formBean.toURLParam(expand);%>
                <table class="sortable" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                  <thead>
                    <tr>
                      <%
                        if (showLevel) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsPhrase("Level")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showEUNISCode) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode))%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showANNEXCode) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showScientificName) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsPhrase("Habitat type name")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showEnglishName) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsPhrase("English name")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showDescription) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESCRIPTION%>&amp;ascendency=<%=formBean.changeAscendency(sortDescription, (null == sortDescription) ? true : false)%>"><%=Utilities.getSortImageTag(sortDescription)%>Description</a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showPriority) {
                      %>
                      <th scope="col" style="text-align : center;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PRIORITY%>&amp;ascendency=<%=formBean.changeAscendency(sortPriority, (null == sortPriority) ? true : false)%>"><%=Utilities.getSortImageTag(sortPriority)%>Priority</a>
                      </th>
                      <%
                        }
                      %>
                    </tr>
                  </thead>
                  <tbody>
                <%
                  int i = 0;
                  while (it.hasNext()) {
                    ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryPersist habitat = (ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryPersist) it.next();
                    String cssClass = i++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                    int level = habitat.getHabLevel().intValue();
                    //boolean isEUNIS = (Utilities.EUNIS_HABITAT.intValue() == (Utilities.getHabitatType(habitat.getCodeAnnex1()).intValue())) ? true : false;
                    int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
                    boolean isEUNIS = idHabitat <= 10000;
                %>
                    <tr<%=cssClass%>>
                      <%if (showLevel) {%>
                      <td style="white-space : nowrap">
                        <%for (int iter = 0; iter < level; iter++) {%>
                        <img src="images/mini/lev_blank.gif" alt="" /><%}%><%=level%></td>
                      <%}%>
                      <%if (showEUNISCode) {%>
                      <td>
                        <%=isEUNIS ? habitat.getEunisHabitatCode() : "&nbsp;"%>
                      </td>
                      <%}%>
                      <%if (showANNEXCode) {%>
                      <td>
                        <%=isEUNIS ? "&nbsp;" : habitat.getCodeAnnex1()%>
                      </td>
                      <%}%>
                      <%if (showScientificName) {%>
                        <td>
                          <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
                        </td>
                      <%}%>
                      <%if (showEnglishName) {%>
                      <td>
                        <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getDescription()%></a></td>
                      <%}%>
                      <%if (showDescription) {%>
                      <td style="white-space:nowrap">
                        <a href="habitats/<%=habitat.getIdHabitat()%>"><%=habitat.getDescription()%></a></td>
                      <%}%>
                      <%if (showPriority) {%>
                      <td style="text-align : center;">
                        <%=habitat.getPriority() != null && 1 == habitat.getPriority().shortValue() ? cm.cmsPhrase("yes") : cm.cmsPhrase("no")%>
                      </td>
                      <%}%>
                    </tr>
                <%}%>
                  </tbody>
                  <thead>
                    <tr>
                      <%
                        if (showLevel) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsPhrase("Level")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showEUNISCode) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode))%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsPhrase("EUNIS Code")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showANNEXCode) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsPhrase("ANNEX I Code")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showScientificName) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsPhrase("Habitat type name")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showEnglishName) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsPhrase("English name")%></a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showDescription) {
                      %>
                      <th scope="col">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESCRIPTION%>&amp;ascendency=<%=formBean.changeAscendency(sortDescription, (null == sortDescription) ? true : false)%>"><%=Utilities.getSortImageTag(sortDescription)%>Description</a>
                      </th>
                      <%
                        }
                      %>
                      <%
                        if (showPriority) {
                      %>
                      <th scope="col" style="text-align : center;">
                        <a title="<%=cm.cmsPhrase("Sort results on this column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PRIORITY%>&amp;ascendency=<%=formBean.changeAscendency(sortPriority, (null == sortPriority) ? true : false)%>"><%=Utilities.getSortImageTag(sortPriority)%>Priority</a>
                      </th>
                      <%
                        }
                      %>
                    </tr>
                  </thead>
                </table>
                <jsp:include page="navigator.jsp">
                  <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                  <jsp:param name="pageName" value="<%=pageName%>" />
                  <jsp:param name="guid" value="<%=guid + 1%>" />
                  <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                  <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                </jsp:include>
                </td>
                </tr>
                </table>
                  <%=cm.cmsMsg("habitats_advanced-results_title")%>
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
                <jsp:param name="page_name" value="habitats-advanced-results.jsp" />
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
