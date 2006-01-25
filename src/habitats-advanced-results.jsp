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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" type="text/javascript" src="script/species-result.js"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_advanced-results_title")%>
  </title>
</head>
<jsp:useBean id="formBean" class="ro.finsiel.eunis.formBeans.CombinedSearchBean" scope="page">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  AbstractPaginator paginator;
  // Database where to search. Possible values are: Species, Habitats or Sites
  String searchedDatabase = formBean.getSearchedNatureObject();
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
  boolean showLegalInstruments = (columnsDisplayed.contains("showLegalInstruments"));
  boolean showCountry = (columnsDisplayed.contains("showCountry"));
  boolean showRegion = (columnsDisplayed.contains("showRegion"));
  boolean showReferences = (columnsDisplayed.contains("showReferences"));
  boolean showDiagram = (columnsDisplayed.contains("showDiagram"));
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
%>
<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home_location#index.jsp,habitats_location#habitats.jsp,habitats_advanced_search_location#habitats-advanced.jsp,results_location" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<%=cm.cmsText("habitats_advanced-results_01")%>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
      <%=cm.cmsText("habitats_advanced-results_02")%>
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">
      <%=cm.cmsText("habitats_advanced-results_03")%>
      :<%=SessionManager.getExplainedcriteria()%>
      , <%=cm.cmsText("habitats_advanced-results_04")%>:
    </td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">
      <%=SessionManager.getListcriteria()%>
    </td>
  </tr>
</table>
<%if (results.isEmpty()) {%><jsp:include page="noresults.jsp" /><%return;
}%>
  <br />
  <%=cm.cmsText("habitats_advanced-results_05")%>:&nbsp;<strong><%=resultsCount%></strong>
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
<table summary="<%=cm.cms("search_results")%>" border="1" cellpadding="0" cellspacing="0" width="100%" style="border-collapse: collapse">
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
<tr>
  <%
    if (showLevel) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsText("habitats_advanced-results_06")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showEUNISCode) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode))%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsText("habitats_advanced-results_07")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showANNEXCode) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsText("habitats_advanced-results_08")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsText("habitats_advanced-results_09")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showEnglishName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsText("habitats_advanced-results_10")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showDescription) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESCRIPTION%>&amp;ascendency=<%=formBean.changeAscendency(sortDescription, (null == sortDescription) ? true : false)%>"><%=Utilities.getSortImageTag(sortDescription)%>Description</a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showPriority) {
  %>
  <th class="resultHeader" style="text-align : center;">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PRIORITY%>&amp;ascendency=<%=formBean.changeAscendency(sortPriority, (null == sortPriority) ? true : false)%>"><%=Utilities.getSortImageTag(sortPriority)%>Priority</a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
</tr>
<%
  int i = 0;
  while (it.hasNext()) {
    ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryPersist habitat = (ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryPersist) it.next();
    String bgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
    int level = habitat.getHabLevel().intValue();
    //boolean isEUNIS = (Utilities.EUNIS_HABITAT.intValue() == (Utilities.getHabitatType(habitat.getCodeAnnex1()).intValue())) ? true : false;
    int idHabitat = Utilities.checkedStringToInt(habitat.getIdHabitat(), -1);
    boolean isEUNIS = idHabitat <= 10000;
%>
<tr>
  <%if (showLevel) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap">
    <%for (int iter = 0; iter < level; iter++) {%>
    <img src="images/mini/lev_blank.gif" alt="" /><%}%><%=level%></td>
  <%}%>
  <%if (showEUNISCode) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=isEUNIS ? habitat.getEunisHabitatCode() : "&nbsp;"%>
  </td>
  <%}%>
  <%if (showANNEXCode) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=isEUNIS ? "&nbsp;" : habitat.getCodeAnnex1()%>
  </td>
  <%}%>
  <%if (showScientificName) {%>
    <td class="resultCell" style="background-color : <%=bgColor%>">
      <a title="<%=cm.cms("open_habitat_type_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a>
      <%=cm.cmsMsg("open_habitat_type_factsheet")%>
    </td>
  <%}%>
  <%if (showEnglishName) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <a title="<%=cm.cms("open_habitat_type_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getDescription()%></a></td>
  <%}%>
  <%if (showDescription) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space:nowrap">
    <a title="<%=cm.cms("open_habitat_type_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getDescription()%></a></td>
  <%}%>
  <%if (showPriority) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>; text-align : center;">
    <%=habitat.getPriority() != null && 1 == habitat.getPriority().shortValue() ? cm.cmsText("yes") : cm.cmsText("no")%>
  </td>
  <%}%>
</tr>
<%}%>
<tr>
  <%
    if (showLevel) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(sortLevel, (null == sortLevel) ? true : false)%>"><%=Utilities.getSortImageTag(sortLevel)%><%=cm.cmsText("habitats_advanced-results_06")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showEUNISCode) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortEunisCode, (null == sortEunisCode))%>"><%=Utilities.getSortImageTag(sortEunisCode)%><%=cm.cmsText("habitats_advanced-results_07")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showANNEXCode) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(sortAnnexCode, (null == sortAnnexCode) ? true : false)%>"><%=Utilities.getSortImageTag(sortAnnexCode)%><%=cm.cmsText("habitats_advanced-results_08")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortScientificName, (null == sortScientificName) ? true : false)%>"><%=Utilities.getSortImageTag(sortScientificName)%><%=cm.cmsText("habitats_advanced-results_09")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showEnglishName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_ENGLISH_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortEnglishName, (null == sortEnglishName) ? true : false)%>"><%=Utilities.getSortImageTag(sortEnglishName)%><%=cm.cmsText("habitats_advanced-results_10")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showDescription) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_DESCRIPTION%>&amp;ascendency=<%=formBean.changeAscendency(sortDescription, (null == sortDescription) ? true : false)%>"><%=Utilities.getSortImageTag(sortDescription)%><%=cm.cmsText("habitats_advanced-results_description")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showPriority) {
  %>
  <th class="resultHeader" style="text-align : center;">
    <a title="<%=cm.cms("sort_results_on_this_column")%> " href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=AdvancedSortCriteria.SORT_PRIORITY%>&amp;ascendency=<%=formBean.changeAscendency(sortPriority, (null == sortPriority) ? true : false)%>"><%=Utilities.getSortImageTag(sortPriority)%><%=cm.cmsText("habitats_advanced-results_priority")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
</tr>
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
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-advanced-results.jsp" />
</jsp:include>
  </div>
  </div>
  </div>
</body>
</html>