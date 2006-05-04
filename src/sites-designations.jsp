<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : "Sites Designation types" function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement"%>
<%@ page import="ro.finsiel.eunis.utilities.Accesibility"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
    <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
%>
    <script language="JavaScript" type="text/javascript" src="script/sites-designated-codes.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <script language="JavaScript" type="text/javascript" src="script/sites-designations-save-criteria.js"></script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("sites_designations_title")%>
    </title>
  </head>
  <body>
    <div id="outline">
    <div id="alignment">
    <div id="content">
      <jsp:include page="header-dynamic.jsp">
        <jsp:param name="location" value="home#index.jsp,sites#sites.jsp,designation_types"/>
        <jsp:param name="helpLink" value="sites-help.jsp"/>
        <jsp:param name="mapLink" value="show"/>
      </jsp:include>
      <form name="eunis" method="get" onsubmit="javascript: return validateForm();" action="sites-designations-result.jsp">
        <input type="hidden" name="source" value="sitedesignatedname" />
        <h1>
          <%=cm.cmsText("designation_types")%>
        </h1>

        <%=cm.cmsText("sites_designations_19")%>
        <br />
        <br />
        <div class="grey_rectangle">
          <strong>
            <%=cm.cmsText("search_will_provide")%>
          </strong>
          <br />
          <input id="showSourceDB" name="showSourceDB" type="checkbox" value="true" checked="checked" title="<%=cm.cms("source_data_set_2")%>" />
          <label for="showSourceDB"><%=cm.cmsText("source_data_set_2")%></label>
          <%=cm.cmsTitle("source_data_set_2")%>

          <input id="showIso" name="showIso" type="checkbox" value="true" checked="checked" title="<%=cm.cms("country_1")%>" />
          <label for="showIso"><%=cm.cmsText("country_1")%></label>
          <%=cm.cmsTitle("country_1")%>

          <input id="showDesignation" name="showDesignation" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_04")%>" />
          <label for="showDesignation"><%=cm.cmsText("sites_designations_04")%></label>
          <%=cm.cmsTitle("sites_designations_04")%>

          <input id="showDesignationEn" name="showDesignationEn" type="checkbox" disabled="disabled" value="true" checked="checked" title="<%=cm.cms("sites_designations_05")%>" />
          <label for="showDesignationEn"><%=cm.cmsText("sites_designations_05")%></label>
          <%=cm.cmsTitle("sites_designations_05")%>

          <input id="showDesignationFr" name="showDesignationFr" type="checkbox" value="true" title="<%=cm.cms("sites_designations_06")%>" />
          <label for="showDesignationFr"><%=cm.cmsText("sites_designations_06")%></label>
          <%=cm.cmsTitle("sites_designations_06")%>

          <input id="showAbreviation" name="showAbreviation" type="checkbox" value="true" checked="checked" title="<%=cm.cms("sites_designations_08")%>" />
          <label for="showAbreviation"><%=cm.cmsText("sites_designations_08")%></label>
          <%=cm.cmsTitle("sites_designations_08")%>
        </div>
        <img style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_mandatory")%>
        <strong>
          <%=cm.cmsText("original_english_french_designation_name")%>
        </strong>
        <label for="relationOp" class="noshow"><%=cm.cms("operator")%></label>
        <select id="relationOp" name="relationOp" class="inputTextField" title="<%=cm.cms("operator")%>">
          <option value="<%=Utilities.OPERATOR_IS%>">
            <%=cm.cms("is")%>
          </option>
          <option value="<%=Utilities.OPERATOR_CONTAINS%>">
            <%=cm.cms("contains")%>
          </option>
          <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected">
            <%=cm.cms("starts_with")%>
          </option>
        </select>
        <%=cm.cmsLabel("operator")%>
        <%=cm.cmsTitle("operator")%>
        <%=cm.cmsInput("is")%>
        <%=cm.cmsInput("contains")%>
        <%=cm.cmsInput("starts_with")%>
        <label for="searchString" class="noshow"><%=cm.cms("designation_name")%></label>
        <input id="searchString" name="searchString" value="" size="32" class="inputTextField" title="<%=cm.cms("designation_name")%>" />
        <%=cm.cmsLabel("designation_name")%>
        <%=cm.cmsTitle("designation_name")%>

        <a title="<%=cm.cms("helper")%>" href="javascript:openHelper('sites-designations-choice.jsp','no')"><img src="images/helper/helper.gif" alt="<%=cm.cms("helper")%>" title="<%=cm.cms("helper")%>" width="11" height="18" border="0" style="vertical-align:middle" /></a>
        <%=cm.cmsTitle("helper")%>
        <%=cm.cmsAlt("helper")%>
        <br />
        <img style="vertical-align:middle" alt="<%=cm.cms("field_optional")%>" title="<%=cm.cms("field_optional")%>" src="images/mini/field_optional.gif" width="11" height="12" />
        <%=cm.cmsAlt("field_optional")%>
        <label for="category">
          <strong>
            <%=cm.cmsText("designation_category")%>
          </strong>
        </label>
        <select id="category" name="category" class="inputTextField" title="<%=cm.cms("designation_category")%>">
          <option value="A"><%=cm.cms("sites_designations_cata")%></option>
          <option value="B"><%=cm.cms("sites_designations_catb")%></option>
          <option value="C"><%=cm.cms("sites_designations_catc")%></option>
          <option value="any" selected="selected">
            <%=cm.cms("any")%>
          </option>
        </select>
        <%=cm.cmsLabel("designation_category")%>
        <%=cm.cmsTitle("designation_category")%>
        <%=cm.cmsInput("any")%>
        <%=cm.cmsInput("sites_designations_cata")%>
        <%=cm.cmsInput("sites_designations_catb")%>
        <%=cm.cmsInput("sites_designations_catc")%>

        <div class="submit_buttons">
          <input id="reset" name="Reset" type="reset" value="<%=cm.cms("reset")%>" class="inputTextField" title="<%=cm.cms("reset_values")%>" />
          <%=cm.cmsTitle("reset_values")%>
          <%=cm.cmsInput("reset")%>

          <input id="submit2" name="submit2" type="submit" class="inputTextField" value="<%=cm.cms("search")%>" title="<%=cm.cms("search")%>" />
          <%=cm.cmsTitle("search")%>
          <%=cm.cmsInput("search")%>
        </div>
        <jsp:include page="sites-search-common.jsp" />
      </form>
<%
  // Save search criteria
  if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
  {
    // Set Vector for URL string
    Vector show = new Vector();
    show.addElement("showSource");
    show.addElement("showDesignation");
    show.addElement("showDesignationEn");
    show.addElement("showDesignationFr");
    show.addElement("showSourceDB");
    show.addElement("showIso");
    show.addElement("showAbreviation");
    String pageName = "sites-designations.jsp";
    String pageNameResult = "sites-designations-result.jsp?"+Utilities.writeURLCriteriaSave(show);
    // Expand or not save criterias list
    String expandSearchCriteria = (request.getParameter("expandSearchCriteria")==null?"no":request.getParameter("expandSearchCriteria"));
%>
      <br />
    <%=cm.cmsText("save_your_criteria_1")%>
    <a title="<%=cm.cms("save")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'sites-designations.jsp','3','eunis',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img border="0" alt="<%=cm.cms("save")%>" title="<%=cm.cms("save")%>" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
    <%=cm.cmsTitle("save")%>
    <%=cm.cmsAlt("save")%>
    <jsp:include page="show-criteria-search.jsp">
      <jsp:param name="pageName" value="<%=pageName%>" />
      <jsp:param name="pageNameResult" value="<%=pageNameResult%>" />
      <jsp:param name="expandSearchCriteria" value="<%=expandSearchCriteria%>" />
    </jsp:include>
<%
  }
%>

      <%=cm.cmsMsg("sites_designations_title")%>
      <jsp:include page="footer.jsp">
        <jsp:param name="page_name" value="sites-designations.jsp" />
      </jsp:include>
    </div>
    </div>
    </div>
  </body>
</html>