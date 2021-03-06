<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species synonyms' function - results page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSearchCriteria,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsPaginator,
                 ro.finsiel.eunis.search.species.synonyms.SynonymsSortCriteria,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNameDomain,
                 ro.finsiel.eunis.search.AbstractPaginator,
                 ro.finsiel.eunis.search.AbstractSortCriteria,
                 ro.finsiel.eunis.search.AbstractSearchCriteria,
                 ro.finsiel.eunis.jrfTables.species.synonyms.ScientificNamePersist,
                 ro.finsiel.eunis.utilities.TableColumns"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<jsp:useBean id="formBean" class="ro.finsiel.eunis.search.species.synonyms.SynonymsBean" scope="request">
  <jsp:setProperty name="formBean" property="*" />
</jsp:useBean>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // Prepare the search in results (fix)
  if (null != formBean.getRemoveFilterIndex()) { formBean.prepareFilterCriterias(); }
  // Initialization
  int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);
  SynonymsPaginator paginator = new SynonymsPaginator(new ScientificNameDomain(formBean.toSearchCriteria(),
                                                                                formBean.toSortCriteria(),
                                                                                SessionManager.getShowEUNISInvalidatedSpecies()));
  paginator.setSortCriteria(formBean.toSortCriteria());
  paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));
  currentPage = paginator.setCurrentPage(currentPage);// Compute *REAL* current page (adjusted if user messes up)
  String pageName = "species-synonyms-result.jsp";
  int resultsCount = paginator.countResults();
  int pagesCount = paginator.countPages();// This is used in @page include...
  int guid = 0;// This is used in @page include...
  // Now extract the results for the current page.
  List results = new ArrayList();
  try
  {
   results = paginator.getPage(currentPage);
  }
  catch ( Exception ex )
  {
    ex.printStackTrace();
  }
  // Set number criteria for the search result
  int noCriteria = (null==formBean.getCriteriaSearch()? 0 : formBean.getCriteriaSearch().length);
  // Prepare parameters for tsv
  Vector reportFields = new Vector();
  reportFields.addElement("sort");
  reportFields.addElement("ascendency");
  reportFields.addElement("criteriaSearch");
  reportFields.addElement("oper");
  reportFields.addElement("criteriaType");
  String tsvLink = "javascript:openTSVDownload('reports/species/tsv-species-synonyms.jsp?" + formBean.toURLParam(reportFields) + "')";
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String location = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,synonyms#species-synonyms.jsp,results";
  if (results.isEmpty())
  {
    boolean fromRefine = formBean.getCriteriaSearch() != null && formBean.getCriteriaSearch().length > 0;
%>
      <jsp:forward page="emptyresults.jsp">
        <jsp:param name="location" value="<%=location%>" />
        <jsp:param name="fromRefine" value="<%=fromRefine%>" />
      </jsp:forward>
<%
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="<%=request.getContextPath()%>/script/species-result.js"></script>
    <script language="JavaScript" type="text/javascript">
      //<![CDATA[
        var errRefineMessage = "<%=cm.cms("species_synonyms-result_15")%>";
        // Used in refine search ; check if criteria are empty
        function checkRefineSearch(noCriteria)
        {
          if(noCriteria == 0)
          {
            Name = trim(document.resultSearch.criteriaSearch.value);
            if (Name == "")
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          } else {
            var isSomeoneEmplty = 0;
            for (i = 0; i <= noCriteria; i++)
            {
              if (trim(document.resultSearch.criteriaSearch[i].value) == "")
              {
                isSomeoneEmplty = 1;
              }
            }
            if (isSomeoneEmplty == 1)
            {
              alert(errRefineMessage);
              return false;
            } else {
              return true;
            }
          }
        }
       //]]>
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_synonyms-result_title")%>
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
                <h1>
                      <%=cm.cmsPhrase("Synonyms search results")%>
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
                <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                        <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
            <%
                             // Get search description
                             StringBuffer descr = Utilities.prepareHumanString("", formBean.getScientificName(), Utilities.checkedStringToInt(formBean.getRelationOp(), Utilities.OPERATOR_CONTAINS));
                             String s = "";
                             // Not any group
                             if (!formBean.getGroupName().equals("0"))
                             {
                               String groupName = Utilities.getGroupName(formBean.getGroupName());
                               groupName = (groupName == null ? "" : groupName.replaceAll("&","&amp;"));
                               s = " from group <strong>" + Utilities.treatURLAmp(groupName) +"</strong>";
                             }
            %>
                          <tr>
                            <td>
                              <%=cm.cmsPhrase("You searched synonyms for species with scientific name")%>
                              <strong>
                                  <%=Utilities.treatURLAmp(descr.toString())%>
                              </strong>
                              <%=s%>.
                            </td>
                          </tr>
                        </table>
                        <br />
                        <%=cm.cmsPhrase("Results found")%>: <strong><%=resultsCount%></strong>
            <%// Prepare parameters for pagesize.jsp
                        Vector pageSizeFormFields = new Vector();       /*  These fields are used by pagesize.jsp, included below.    */
                        pageSizeFormFields.addElement("sort");          /*  *NOTE* I didn't add currentPage & pageSize since pageSize */
                        pageSizeFormFields.addElement("ascendency");    /*   is overriden & also pageSize is set to default           */
                        pageSizeFormFields.addElement("criteriaSearch");/*   to page '0' aka first page. */
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
                        filterSearch.addElement("criteriaSearch");
                        filterSearch.addElement("pageSize");
            %>
                      <br />
                      <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0" style="background-color:#EEEEEE">
                        <tr>
                          <td>
                              <%=cm.cmsPhrase("Refine your search")%>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <form name="resultSearch" method="get" onsubmit="return(checkRefineSearch(<%=noCriteria%>));" action="" >
                              <%=formBean.toFORMParam(filterSearch)%>
                              <label for="select1" class="noshow"><%=cm.cmsPhrase("Criteria")%></label>
            <%
                // Not any group
                if (!formBean.getGroupName().equals("0"))
                {
            %>
                              <input type="hidden" name="criteriaType" value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" />
            <%
                }
            %>

                              <select id="select1" title="<%=cm.cmsPhrase("Criteria")%>" name="criteriaType" <%=(formBean.getGroupName().equals("0") ? "" : "disabled=\"disabled\"")%>>
            <%
                                // Any group
                                if (formBean.getGroupName().equals("0"))
                                {
            %>
                                  <option value="<%=SynonymsSearchCriteria.CRITERIA_GROUP%>">
                                    <%=cm.cmsPhrase("Group")%>
                                  </option>
            <%
                                }
            %>
            <%--                    <OPTION value="<%=SynonymsSearchCriteria.CRITERIA_ORDER%>" selected>--%>
            <%--                      Order--%>
            <%--                    </OPTION>--%>
            <%--                    <OPTION value="<%=SynonymsSearchCriteria.CRITERIA_FAMILY%>" selected>--%>
            <%--                      Family--%>
            <%--                    </OPTION>--%>
                                <option value="<%=SynonymsSearchCriteria.CRITERIA_SCIENTIFIC_NAME%>" selected="selected">
                                  <%=cm.cms("synonym")%>
                                </option>
                              </select>
                              <select id="select2" title="<%=cm.cmsPhrase("Operator")%>" name="oper">
                                <option value="<%=Utilities.OPERATOR_IS%>" selected="selected">
                                    <%=cm.cmsPhrase("is")%>
                                </option>
                                <option value="<%=Utilities.OPERATOR_STARTS%>">
                                    <%=cm.cmsPhrase("starts with")%>
                                </option>
                                <option value="<%=Utilities.OPERATOR_CONTAINS%>">
                                    <%=cm.cmsPhrase("contains")%>
                                </option>
                              </select>
                              <label for="criteriaSearch" class="noshow"><%=cm.cmsPhrase("Filter value")%></label>
                              <input id="criteriaSearch" title="<%=cm.cmsPhrase("Filter value")%>" alt="<%=cm.cmsPhrase("Filter value")%>" name="criteriaSearch" type="text" size="30" />
                              <input id="refine" title="<%=cm.cmsPhrase("Search")%>" class="submitSearchButton" type="submit" name="Submit" value="<%=cm.cmsPhrase("Search")%>" />
                            </form>
                          </td>
                        </tr>
                        <%-- This is the code which shows the search filters --%>
            <%
                          AbstractSearchCriteria[] criterias = formBean.toSearchCriteria();
                          if (criterias.length > 1)
                          {
            %>
                            <tr>
                              <td>
                                <%=cm.cmsPhrase("Applied filters to the results")%>:
                              </td>
                            </tr>
            <%
                          }
                          for (int i = criterias.length - 1; i > 0; i--)
                          {
                            AbstractSearchCriteria criteria = criterias[i];
                            if (null != criteria && null != formBean.getCriteriaSearch())
                            {
            %>
                              <tr>
                                <td>
                                  <a title="<%=cm.cms("delete_criteria")%>" href="<%= pageName%>?<%=formBean.toURLParam(filterSearch)%>&amp;removeFilterIndex=<%=i%>"><img alt="<%=cm.cms("delete_criteria")%>" src="images/mini/delete.jpg" border="0" style="vertical-align:middle" /></a><%=cm.cmsTitle("delete_criteria")%>&nbsp;&nbsp;<strong class="linkDarkBg"><%= i + ". " + criteria.toHumanString()%></strong>
                                </td>
                              </tr>
            <%
                            }
                          }
            %>
                    </table>
            <%
                      Vector navigatorFormFields = new Vector();  /*  The following fields are used by paginator.jsp, included below.      */
                      navigatorFormFields.addElement("pageSize"); /* NOTE* that I didn't add here currentPage since it is overriden in the */
                      navigatorFormFields.addElement("sort");     /* <form name='..."> in the navigator.jsp!                               */
                      navigatorFormFields.addElement("ascendency");
                      navigatorFormFields.addElement("criteriaSearch");
            %>
                    <jsp:include page="navigator.jsp">
                      <jsp:param name="pagesCount" value="<%=pagesCount%>" />
                      <jsp:param name="pageName" value="<%=pageName%>" />
                      <jsp:param name="guid" value="<%=guid%>" />
                      <jsp:param name="currentPage" value="<%=formBean.getCurrentPage()%>" />
                      <jsp:param name="toURLParam" value="<%=formBean.toURLParam(navigatorFormFields)%>" />
                      <jsp:param name="toFORMParam" value="<%=formBean.toFORMParam(navigatorFormFields)%>" />
                    </jsp:include>
                        <%
                                    // Compute the sort criteria
                                    Vector sortURLFields = new Vector();      /* Used for sorting */
                                    sortURLFields.addElement("pageSize");
                                    sortURLFields.addElement("criteriaSearch");
                                    String urlSortString = formBean.toURLParam(sortURLFields);
                                    AbstractSortCriteria sortGroup = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_GROUP);
//            AbstractSortCriteria sortOrder = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_ORDER);
//            AbstractSortCriteria sortFamily = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_FAMILY);
                                    AbstractSortCriteria sortSciName = formBean.lookupSortCriteria(SynonymsSortCriteria.SORT_SCIENTIFIC_NAME);
                        %>
                    <table class="sortable" width="100%" summary="<%=cm.cmsPhrase("Search results")%>">
                      <thead>
                        <tr>
                          <th scope="col">
            <%
            if (formBean.getGroupName().equals("0"))
                {
            %>
                            <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
            <%
                }else
                {
            %>
                            <%=cm.cmsPhrase("Group")%>
            <%
                }
            %>
                          </th>
                          <th scope="col">
                            <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Synonym")%></a>
                          </th>
                          <th scope="col">
                            <%=cm.cmsPhrase("Species scientific name")%>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
            <%
                        Iterator it = results.iterator();
                        int col = 0;
                        while (it.hasNext())
                        {
                          String cssClass = col++ % 2 == 0 ? " class=\"zebraeven\"" : "";
                          ScientificNamePersist specie = (ScientificNamePersist)it.next();
            %>
                        <tr<%=cssClass%>>
                          <td>
                            <%=Utilities.treatURLSpecialCharacters(Utilities.formatString(specie.getGrName()))%>
                          </td>
            <%--            <td>--%>
            <%--              <%=Utilities.formatString(specie.getTaxonomicNameOrder(),"&nbsp;")%>--%>
            <%--            </td>--%>
            <%--            <td>--%>
            <%--              <%=Utilities.formatString(specie.getTaxonomicNameFamily(),"&nbsp;")%>--%>
            <%--            </td>--%>
                          <td>
                            <a href="species/<%=specie.getIdSpec()%>"><%=Utilities.treatURLSpecialCharacters(specie.getScName())%></a>
                          </td>
                          <td>
                        <%
                           List resultsSpecies = new ScientificNameDomain(formBean.toSearchCriteria(),formBean.toSortCriteria(),SessionManager.getShowEUNISInvalidatedSpecies()).geSpeciesListForASynonym(specie.getIdSpec());
                           if (resultsSpecies != null && resultsSpecies.size() > 0)
                         {
                         %>
                            <table summary="<%=cm.cms("list_species")%>" width="100%" border="0" cellspacing="0" cellpadding="0">
                         <%
                           for(int ii=0;ii<resultsSpecies.size();ii++)
                           {
                             TableColumns tableColumns = (TableColumns) resultsSpecies.get(ii);
                             String scientificName = (String)tableColumns.getColumnsValues().get(0);
                             Integer idSpecies = (Integer)tableColumns.getColumnsValues().get(1);
                           %>
                              <tr>
                                <td>
                                  <a href="species/<%=idSpecies%>"><%=Utilities.treatURLSpecialCharacters(scientificName)%></a>
                                </td>
                              </tr>
                           <%
                           }
                         %>
                            </table>
                         <%
                         }
                         %>
                          </td>
                        </tr>
            <%
                        }
            %>
                      </tbody>
                      <thead>
                        <tr>
                          <th scope="col">
            <%
            if (formBean.getGroupName().equals("0"))
                {
            %>
                            <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_GROUP%>&amp;ascendency=<%=formBean.changeAscendency(sortGroup, (null == sortGroup) ? true : false)%>"><%=Utilities.getSortImageTag(sortGroup)%><%=cm.cmsPhrase("Group")%></a>
            <%
                }else
                {
            %>
                            <%=cm.cmsPhrase("Group")%>
            <%
                }
            %>
                          </th>
                          <th scope="col">
                            <a title="<%=cm.cmsPhrase("Sort results on this column")%>" href="<%=pageName + "?" + urlSortString%>&amp;sort=<%=SynonymsSortCriteria.SORT_SCIENTIFIC_NAME%>&amp;ascendency=<%=formBean.changeAscendency(sortSciName, (null == sortSciName) ? true : false)%>"><%=Utilities.getSortImageTag(sortSciName)%><%=cm.cmsPhrase("Synonym")%></a>
                          </th>
                          <th scope="col">
                            <%=cm.cmsPhrase("Species scientific name")%>
                          </th>
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

            <%=cm.br()%>
            <%=cm.cmsMsg("species_synonyms-result_15")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("species_synonyms-result_title")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("synonym")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("list_species")%>
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
                <jsp:param name="page_name" value="species-synonyms-result.jsp" />
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
