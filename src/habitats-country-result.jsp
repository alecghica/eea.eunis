<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats country' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.formBeans.AbstractFormBean,
                 ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain,
                 ro.finsiel.eunis.jrfTables.habitats.country.CountryPersist,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.habitats.country.CountryPaginator,
                 ro.finsiel.eunis.search.habitats.country.CountrySearchCriteria,
                 ro.finsiel.eunis.search.habitats.country.CountrySortCriteria,
                 java.util.Iterator,
                 java.util.List,
                 java.util.Vector" %>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
<head>
  <jsp:include page="header-page.jsp" />
  <script language="JavaScript" src="script/habitats-result.js" type="text/javascript"></script>
  <%
    WebContentManagement cm = SessionManager.getWebContent();
  %>
  <title>
    <%=application.getInitParameter("PAGE_TITLE")%>
    <%=cm.cms("habitats_country-result_title")%>
  </title>
  <%// Get form parameters here%>
  <jsp:useBean id="formBean" class="ro.finsiel.eunis.search.habitats.country.CountryBean" scope="request">
    <jsp:setProperty name="formBean" property="*" />
  </jsp:useBean>
  <%
    // Prepare the search in results (fix)
    if (null != formBean.getRemoveFilterIndex()) {
      formBean.prepareFilterCriterias();
    }
    // Requets parameters
    boolean showLevel = Utilities.checkedStringToBoolean(formBean.getShowLevel(), AbstractFormBean.HIDE);
    boolean showCode = Utilities.checkedStringToBoolean(formBean.getShowCode(), AbstractFormBean.HIDE);
    boolean showScientificName = Utilities.checkedStringToBoolean(formBean.getShowScientificName(), AbstractFormBean.HIDE);
    boolean showVernacularName = Utilities.checkedStringToBoolean(formBean.getShowVernacularName(), AbstractFormBean.HIDE);
    boolean showCountry = true;
    boolean showRegion = true;

    // Set number criteria for the search result
    int noCriteria = (null == formBean.getCriteriaSearch() ? 0 : formBean.getCriteriaSearch().length);

    int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
    Integer database = Utilities.checkedStringToInt(formBean.getDatabase(), CountryDomain.SEARCH_EUNIS);
    // The main paginator
    CountryPaginator paginator = new CountryPaginator(new CountryDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), database));
    // Initialization
    paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
    paginator.setSortCriteria(formBean.toSortCriteria());
    currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)

    // This is used in @page include...
    int resultsCount = paginator.countResults();
    final String pageName = "habitats-country-result.jsp";
    int pagesCount = paginator.countPages();
    int guid = 0;
    // Now extract the results for the current page.
    List results = paginator.getPage(currentPage);

    // Prepare parameters for tsvlink
    Vector reportFields = new Vector();
    reportFields.addElement("sort");
    reportFields.addElement("ascendency");
    reportFields.addElement("criteriaSearch");
    reportFields.addElement("oper");
    reportFields.addElement("criteriaType");

    String tsvLink = "javascript:openTSVDownload('reports/habitats/tsv-habitats-country.jsp?" + formBean.toURLParam(reportFields) + "')";
  %>
</head>

<body>
  <div id="outline">
  <div id="alignment">
  <div id="content">
<jsp:include page="header-dynamic.jsp">
  <jsp:param name="location" value="home#index.jsp,habitat_types#habitats.jsp,habitats_country_location#habitats-country.jsp,results" />
  <jsp:param name="helpLink" value="habitats-help.jsp" />
  <jsp:param name="downloadLink" value="<%=tsvLink%>" />
</jsp:include>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<h1>
  <%=cm.cmsText("country_biogeographic_region")%>
</h1>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <%AbstractSearchCriteria[] searchCriterias = formBean.toSearchCriteria();
    int whoMuchCriteria = 0;
    for (int i = 0; i < searchCriterias.length; i++) {
      CountrySearchCriteria criteria = (CountrySearchCriteria) searchCriterias[i];
      //System.out.println("criteria: " + criteria.isMainSearch());
      if (null != criteria && criteria.isMainSearch()) {
        whoMuchCriteria++;%>
  <tr>
    <td>
      <%=cm.cmsText("you_searched_for")%>
      <strong>
        <%=Utilities.getSourceHabitat(database, CountryDomain.SEARCH_ANNEX_I.intValue(), CountryDomain.SEARCH_BOTH.intValue())%>
      </strong>
      <%=cm.cmsText("habitat_types")%>
      <strong>
        <%=criteria.toHumanString()%>
      </strong>
    </td>
  </tr>
  <%
    }
  %>
  <%
    }
  %>
</table>
 <%
  if (results.isEmpty())
  {
     boolean fromRefine = false;
     if(formBean != null && formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0)
       fromRefine = true;
%>
     <jsp:include page="noresults.jsp" >
       <jsp:param name="fromRefine" value="<%=fromRefine%>" />
     </jsp:include>
<%
       return;
   }
%>
<%=cm.cmsText("results_found_1")%>:&nbsp;<strong><%=resultsCount%></strong>
<%// Prepare parameters for pagesize.jsp
  Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
  pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
  pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
  pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
  pageSizeFormFields.addElement("oper");
  pageSizeFormFields.addElement("criteriaType");
  pageSizeFormFields.addElement("expand");
%>
<jsp:include page="pagesize.jsp">
  <jsp:param name="guid" value="<%=guid%>" />
  <jsp:param name="pageName" value="<%=pageName%>" />
  <jsp:param name="pageSize" value="<%=formBean.getPageSize()%>" />
  <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(pageSizeFormFields)%>" />
</jsp:include>
<br />
<%// Prepare the form parameters.
  Vector filterSearch = new Vector();
  filterSearch.addElement("sort");
  filterSearch.addElement("ascendency");
  filterSearch.addElement("criteriaSearch");
  filterSearch.addElement("oper");
  filterSearch.addElement("criteriaType");
  filterSearch.addElement("pageSize");
  filterSearch.addElement("expand");%>
<table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td bgcolor="#EEEEEE">
      <strong>
        <%=cm.cmsText("refine_your_search")%>
      </strong>
    </td>
  </tr>
  <tr>
    <td bgcolor="#EEEEEE">
      <form name="resultSearch" method="get" onsubmit="return(checkHabitats(<%=noCriteria%>));" action="habitats-country-result.jsp">
        <%=formBean.toFORMParam(filterSearch)%>
        <label for="criteriaType" class="noshow"><%=cm.cms("criteria")%></label>
        <select title="Criteria" name="criteriaType" id="criteriaType" class="inputTextField">
          <%
            if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
          %>
          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("eunis_code")%></option>
          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("annex_code")%></option>
          <%}%>
          <%if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {%>
          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_EUNIS%>"><%=cm.cms("eunis_code")%></option>
          <%}%>
          <%if (showCode && 0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {%>
          <option value="<%=CountrySearchCriteria.CRITERIA_CODE_ANNEX%>"><%=cm.cms("annex_code")%></option>
          <%}%>
          <%if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS) && showLevel) {%>
          <option value="<%=CountrySearchCriteria.CRITERIA_LEVEL%>"><%=cm.cms("generic_index_07")%></option><%}%>
          <%if (showScientificName) {%>
          <option value="<%=CountrySearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected"><%=cm.cms("habitat_type_name")%></option><%}%>
          <%if (showVernacularName) {%>
          <option value="<%=CountrySearchCriteria.CRITERIA_NAME%>"><%=cm.cms("habitat_type_english_name")%></option><%}%>
        </select>
        <%=cm.cmsLabel("criteria")%>
        <%=cm.cmsInput("eunis_code")%>
        <%=cm.cmsInput("annex_code")%>
        <%=cm.cmsInput("generic_index_07")%>
        <%=cm.cmsInput("habitat_type_name")%>
        <%=cm.cmsInput("habitat_type_english_name")%>
        <label for="oper" class="noshow"><%=cm.cms("operator")%></label>
        <select title="Operator" name="oper" id="oper" class="inputTextField">
          <option value="<%=Utilities.OPERATOR_IS%>" selected="selected"><%=cm.cms("is")%></option>
          <option value="<%=Utilities.OPERATOR_STARTS%>"><%=cm.cms("starts_with")%></option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("contains")%></option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsInput("is")%>
        <%=cm.cmsInput("starts_with")%>
        <%=cm.cmsInput("contains")%>
        <label for="criteriaSearch" class="noshow"><%=cm.cms("filter_value")%></label>
        <input title="<%=cm.cms("filter_value")%>" class="inputTextField" name="criteriaSearch" id="criteriaSearch" type="text" size="30" />
        <%=cm.cmsLabel("filter_value")%>
        <input title="<%=cm.cms("search")%>" class="inputTextField" type="submit" name="Submit" id="Submit" value="<%=cm.cms("search")%>" />
        <%=cm.cmsInput("search")%>
      </form>
    </td>
  </tr>
  <%-- This is the code which shows the search filters --%>
  <%ro.finsiel.eunis.search.AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();%>
  <%if (criterias.length > whoMuchCriteria) {%><tr>
  <td bgcolor="#EEEEEE"><%=cm.cmsText("applied_filters_to_the_results")%>:</td></tr><%}%>
  <%for (int i = criterias.length - 1; i > whoMuchCriteria - 1; i--) {%>
  <%AbstractSearchCriteria criteria = criterias[i];%>
  <%if (null != criteria && null != formBean.getCriteriaSearch()) {%>
  <tr>
    <td bgcolor="#CCCCCC">
      <a title="<%=cm.cms("delete_filter")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i-whoMuchCriteria+1%>"><img src="images/mini/delete.jpg" alt="<%=cm.cms("delete_filter")%>" border="0" style="vertical-align:middle"></a>
      <%=cm.cmsTitle("delete_filter")%>
      &nbsp;&nbsp;
      <strong><%= i + ". " + criteria.toHumanString()%></strong>
    </td>
  </tr>
  <%}%>
  <%}%>
</table>
<%
  // Prepare parameters for navigator.jsp
  Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
  navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
  navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
  navigatorFormFields.addElement("ascendency");
  navigatorFormFields.addElement("criteriaSearch");
  navigatorFormFields.addElement("oper");
  navigatorFormFields.addElement("criteriaType");
  navigatorFormFields.addElement("expand");
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
<%
  // Compute the sort criteria
  Vector sortURLFields = new Vector();      /* Used for sorting */
  sortURLFields.addElement("pageSize");
  sortURLFields.addElement("criteriaSearch");
  sortURLFields.addElement("oper");
  sortURLFields.addElement("criteriaType");
  sortURLFields.addElement("currentPage");
  sortURLFields.addElement("expand");
  String urlSortString = formBean.toURLParam(sortURLFields);
  AbstractSortCriteria levelCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_LEVEL);
  AbstractSortCriteria eunisCodeCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_EUNIS_CODE);
  AbstractSortCriteria annexCodeCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_ANNEX_CODE);
  AbstractSortCriteria sciNameCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_SCIENTIFIC_NAME);
  AbstractSortCriteria nameCrit = formBean.lookupSortCriteria(CountrySortCriteria.SORT_VERNACULAR_NAME);
%>
<tr>
  <%
    if (showCountry) {
  %>
  <th class="resultHeader">
    <%=cm.cmsText("country")%>
  </th>
  <%
    }
  %>
  <%
    if (showRegion) {
  %>
  <th class="resultHeader">
    <%=cm.cmsText("biogeographic_region")%>
  </th>
  <%
    }
  %>
  <%
    if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("generic_index_07")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("eunis_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("annex_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("eunis_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("annex_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitat_type_name")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showVernacularName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitat_type_english_name")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
</tr>
<%
  // Display results
  Iterator it = results.iterator();
  int i = 0;
  while (it.hasNext())
  {
    CountryPersist habitat = (CountryPersist) it.next();
    int level = habitat.getLevel().intValue();
    String bgColor = (0 == (i++ % 2)) ? "#FFFFFF" : "#EEEEEE";
    String eunisCode = habitat.getEunisHabitatCode();
    String annexCode = habitat.getCode2000();
%>
<tr>
  <%if (showCountry) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=habitat.getCountry()%>
  </td>
  <%}%>
  <%if (showRegion) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=habitat.getRegion()%>
  </td>
  <%}%>
  <%if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>; white-space : nowrap">
    <%for (int iter = 0; iter < level; iter++) {%>
    <img alt="" src="images/mini/lev_blank.gif"><%}%><%=level%></td><%}%>
  <%if (showCode) {%>
  <%if (0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=eunisCode%>
  </td>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=annexCode%>
  </td>
  <%}%>
  <%if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=eunisCode%>
  </td>
  <%}%>
  <%if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=annexCode%>
  </td>
  <%}%>
  <%}%>
  <%if (showScientificName) {%>
  <td class="resultCell" style="background-color : <%=bgColor%>">
  <a title="<%=cm.cms("open_habitat_factsheet")%>" href="habitats-factsheet.jsp?idHabitat=<%=habitat.getIdHabitat()%>"><%=habitat.getScientificName()%></a><%=cm.cmsTitle("open_habitat_factsheet")%>
  </td>
  <%
    }
    if (showVernacularName)
    {
  %>
  <td class="resultCell" style="background-color : <%=bgColor%>">
    <%=habitat.getDescription()%>
  </td>
  <%}%>
</tr>
<%}%>
<tr>
  <%
    if (showCountry) {
  %>
  <th class="resultHeader">
    <%=cm.cmsText("country")%>
  </th>
  <%
    }
  %>
  <%
    if (showRegion) {
  %>
  <th class="resultHeader">
    <%=cm.cmsText("biogeographic_region")%>
  </th>
  <%
    }
  %>
  <%
    if (showLevel && 0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_LEVEL%>&amp;ascendency=<%=formBean.changeAscendency(levelCrit, (null == levelCrit))%>"><%=Utilities.getSortImageTag(levelCrit)%><%=cm.cmsText("generic_index_07")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showCode) {
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_BOTH)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("eunis_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("annex_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_EUNIS)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_EUNIS_CODE%>&amp;ascendency=<%=formBean.changeAscendency(eunisCodeCrit, (null == eunisCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(eunisCodeCrit)%><%=cm.cmsText("eunis_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (0 == database.compareTo(CountryDomain.SEARCH_ANNEX_I)) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_ANNEX_CODE%>&amp;ascendency=<%=formBean.changeAscendency(annexCodeCrit, (null == annexCodeCrit) ? true : false)%>"><%=Utilities.getSortImageTag(annexCodeCrit)%><%=cm.cmsText("annex_code")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    }
  %>
  <%
    if (showScientificName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sciNameCrit, (null == sciNameCrit))%>"><%=Utilities.getSortImageTag(sciNameCrit)%><%=cm.cmsText("habitat_type_name")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
  <%
    if (showVernacularName) {
  %>
  <th class="resultHeader">
    <a title="<%=cm.cms("sort_results_on_this_column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=CountrySortCriteria.SORT_VERNACULAR_NAME%>&amp;ascendency=<%=formBean.changeAscendency(nameCrit, (null == nameCrit))%>"><%=Utilities.getSortImageTag(nameCrit)%><%=cm.cmsText("habitat_type_english_name")%></a>
    <%=cm.cmsTitle("sort_results_on_this_column")%>
  </th>
  <%
    }
  %>
</tr>
</table>
</td>
</tr>
<tr>
  <td>
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
  <%=cm.br()%>
  <%=cm.cmsMsg("habitats_country-result_title")%>
  <%=cm.br()%>
<jsp:include page="footer.jsp">
  <jsp:param name="page_name" value="habitats-country-result.jsp" />
</jsp:include>
  </div>
  </div>
  </div>
</body>
</html>