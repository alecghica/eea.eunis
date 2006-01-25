<%--
<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Pick sites, show species' function - search page.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.search.Utilities,
                 java.util.Vector,
                 ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.search.species.sites.SitesSearchCriteria"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
    <script language="JavaScript" type="text/javascript" src="script/save-criteria.js"></script>
    <%
        WebContentManagement cm = SessionManager.getWebContent();
    %>
    <script language="JavaScript" type="text/javascript">
      <!--

      var errInvalidRegion = '<%=cm.cms("species_sites_19")%>';
        // Change the operator list according to criteria selected element from criteria type list
        function changeCriteria() {
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var operList = document.getElementById("relationOp");
          changeOperatorList(criteriaType, operList);
        }

        // Reconstruct the list items depending on the selected item
        function changeOperatorList(criteriaType, operList) {
          removeElementsFromList(operList);
          var optIS = document.createElement("OPTION");
          optIS.text = "<%=cm.cms("is")%>";
          optIS.value = "<%=Utilities.OPERATOR_IS%>";
          var optSTART = document.createElement("OPTION");
          optSTART.text = "<%=cm.cms("starts")%>";
          optSTART.value = "<%=Utilities.OPERATOR_STARTS%>";
          var optCONTAIN = document.createElement("OPTION");
          optCONTAIN.text = "<%=cm.cms("contains")%>";
          optCONTAIN.value = "<%=Utilities.OPERATOR_CONTAINS%>";
          var optGREAT = document.createElement("OPTION");
          optGREAT.text = "<%=cm.cms("greater")%>";
          optGREAT.value = "<%=Utilities.OPERATOR_GREATER_OR_EQUAL%>";
          var optSMALL = document.createElement("OPTION");
          optSMALL.text = "<%=cm.cms("smaller")%>";
          optSMALL.value = "<%=Utilities.OPERATOR_SMALLER_OR_EQUAL%>";
          // Site name
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_NAME%>)
          {
            operList.add(optCONTAIN, 2);
            operList.add(optIS, 0);
            operList.add(optSTART, 1);
          }
          // Site size
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Site length
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            operList.add(optIS, 0);
            operList.add(optGREAT, 1);
            operList.add(optSMALL, 2);
          }
          // Country
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
          // Region
          if (criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            operList.add(optCONTAIN, 1);
            operList.add(optIS, 0);
          }
        }

        // This function removes all the elements of a list
        function removeElementsFromList(operList)
        {
          for (i = operList.length - 1; i >= 0; i--)
          {
            operList.remove(i);
          }
        }

        function validateForm()
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);

          var errMessageName = "<%=cm.cms("species_sites_20")%>";
          var errMessageSize = "<%=cm.cms("species_sites_21")%>";

          // Validate it's selected SIZE?LENGTH
          var criteriaType = document.getElementById("searchAttribute").options[document.getElementById("searchAttribute").selectedIndex].value;
          var searchString = document.criteria.scientificName.value;
          var fSearchString = parseFloat(searchString);

          if ((criteriaType == <%=SitesSearchCriteria.SEARCH_SIZE%> ||
              criteriaType == <%=SitesSearchCriteria.SEARCH_LENGTH%>) && isNaN(fSearchString))
          {
              alert(errMessageSize);
              return false;
          }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_COUNTRY%>)
          {
            // Check if country is a valid country
           if (!validateCountry('<%=Utilities.getCountryListString()%>',searchString))
           {
             alert(errInvalidCountry);
             return false;
           }
         }

          if(criteriaType == <%=SitesSearchCriteria.SEARCH_REGION%>)
          {
            // Check if region is a valid region
           if (!validateRegion('<%=Utilities.getRegionListString()%>',searchString))
           {
             alert(errInvalidRegion);
             return false;
           }
         }

          // Validate the input field
          var siteName;
          siteName = document.criteria.scientificName.value;
          if (siteName == "")
          {
            alert(errMessageName);
            return false;
          }
          // Validate selection of databases
          return checkValidSelection();// From sites-databases.jsp.
        }

        function openHelper(URL)
        {
          document.criteria.scientificName.value = trim(document.criteria.scientificName.value);
          var scientificName = document.criteria.scientificName.value;
          var relationOp = document.criteria.relationOp.value;
          var searchAttribute = document.criteria.searchAttribute.value;
          // If selects attribute scientific name, validate the form for input.
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_NAME%> && !validateForm())
          {
            // Return, form validation failed.
            return;
          }
          if (searchAttribute == <%=SitesSearchCriteria.SEARCH_SIZE%> || searchAttribute == <%=SitesSearchCriteria.SEARCH_LENGTH%>)
          {
            // Return, no popup for size or length
            alert("<%=cm.cms("species_sites_22")%>");
            return;
          }
          if (!checkValidSelection())
          {
            // Return, no database selected
            return;
          }
          URL2 = URL;
          URL2 += '?searchAttribute=' + searchAttribute;
          URL2 += '&scientificName=' + scientificName;
          URL2 += '&relationOp=' + relationOp;
          URL2 += Db2Url();
          eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,resizable=no,location=0,width=400,height=500,left=500,top=0');");
        }
      //-->
    </script>
    <title>
      <%=application.getInitParameter("PAGE_TITLE")%>
      <%=cm.cms("species_sites_title")%>
    </title>
  </head>
  <body style="background-color:#ffffff">
  <div id="outline">
  <div id="alignment">
  <div id="content">
    <jsp:include page="header-dynamic.jsp">
      <jsp:param name="location" value="home_location#index.jsp,sites_location#sites.jsp,pick_sites_show_species_location" />
    </jsp:include>
    <h1>
       <%=cm.cmsText("species_sites_01")%>
    </h1>
    <form name="criteria" method="get" onsubmit="javascript: return validateForm();" action="species-sites-result.jsp">
    <table summary="layout" width="100%" border="0">
        <tr>
          <td colspan="2">
            <%=cm.cmsText("species_sites_20")%>
            <br />
            <br />
            <table summary="layout" width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="background-color:#EEEEEE">
                  <strong>
                    <%=cm.cmsText("species_sites_02")%>
                  </strong>
                </td>
              </tr>
              <tr>
                <td style="background-color:#EEEEEE">
                  <input title="<%=cm.cms("group")%>" id="checkbox1" type="checkbox" name="showGroup" value="true" checked="checked" />
                  <label for="checkbox1"><%=cm.cmsText("species_sites_03")%></label>
                  <%=cm.cmsTitle("group")%>

                  <input title="<%=cm.cms("order")%>" id="checkbox2" type="checkbox" name="showOrder" value="true" checked="checked" />
                  <label for="checkbox2"><%=cm.cmsText("species_sites_04")%></label>
                   <%=cm.cmsTitle("order")%>

                  <input title="<%=cm.cms("family")%>" id="checkbox3" type="checkbox" name="showFamily" value="true" checked="checked" />
                  <label for="checkbox3"><%=cm.cmsText("species_sites_05")%></label>
                  <%=cm.cmsTitle("family")%>

                  <input title="<%=cm.cms("scientific_name")%>" id="checkbox5" type="checkbox" name="showScientificName" value="true" disabled="disabled" checked="checked" />
                  <label for="checkbox5"><%=cm.cmsText("species_sites_06")%></label>
                  <%=cm.cmsTitle("scientific_name")%>

                  <input title="<%=cm.cms("sites")%>" id="checkbox4" type="checkbox" name="showSites" value="true" checked="checked" />
                  <label for="checkbox4"><%=cm.cmsText("species_sites_21")%></label>
                  <%=cm.cmsTitle("sites")%>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <img width="11" height="12" style="vertical-align:middle" alt="<%=cm.cms("field_mandatory")%>" title="<%=cm.cms("field_mandatory")%>" src="images/mini/field_mandatory.gif" /><%=cm.cmsAlt("field_mandatory")%>&nbsp;
            <label for="select1" class="noshow"><%=cm.cms("search_attribute")%></label>
            <select id="select1" title="<%=cm.cms("search_attribute")%>" name="searchAttribute" onchange="changeCriteria()" class="inputTextField">
              <option value="<%=SitesSearchCriteria.SEARCH_NAME%>" selected="selected"><%=cm.cms("species_sites_08")%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_SIZE%>"><%=cm.cms("species_sites_09")%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_LENGTH%>"><%=cm.cms("species_sites_10")%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_COUNTRY%>"><%=cm.cms("species_sites_11")%></option>
              <option value="<%=SitesSearchCriteria.SEARCH_REGION%>"><%=cm.cms("species_sites_12")%></option>
            </select>
            <%=cm.cmsLabel("search_attribute")%>
            <%=cm.cmsTitle("search_attribute")%>
              &nbsp;
            <label for="select2" class="noshow"><%=cm.cms("operator")%></label>
            <select id="select2" title="<%=cm.cms("operator")%>" name="relationOp" class="inputTextField">
              <option value="<%=Utilities.OPERATOR_IS%>"><%=cm.cms("species_sites_13")%></option>
              <option value="<%=Utilities.OPERATOR_CONTAINS%>"><%=cm.cms("species_sites_14")%></option>
              <option value="<%=Utilities.OPERATOR_STARTS%>" selected="selected"><%=cm.cms("species_sites_15")%></option>
            </select>
            <%=cm.cmsLabel("operator")%>
            <%=cm.cmsTitle("operator")%>

            <label for="scientificName" class="noshow"><%=cm.cms("criteria_value")%></label>
            <input title="<%=cm.cms("criteria_value")%>" size="32" id="scientificName" name="scientificName" value="" class="inputTextField" />
            <%=cm.cmsLabel("criteria_value")%>
            <%=cm.cmsTitle("criteria_value")%>
            <a title="<%=cm.cms("list_values_link")%>" href="javascript:openHelper('species-sites-choice.jsp')"><img alt="<%=cm.cms("list_values_link")%>" height="18" src="images/helper/helper.gif" width="11" border="0" title="<%=cm.cms("list_values_link")%>" /></a>
            <%=cm.cmsTitle("list_values_link")%>
          </td>
        </tr>
        <tr>
          <td style="text-align:right">
            <input id="Reset" type="reset" value="<%=cm.cms("reset_btn")%>" name="Reset" class="inputTextField" title="<%=cm.cms("reset")%>" />
            <%=cm.cmsTitle("reset")%>
            <%=cm.cmsInput("reset_btn")%>
            <input id="Search" type="submit" value="<%=cm.cms("search_btn")%>" name="submit2" class="inputTextField" title="<%=cm.cms("search")%>" />
            <%=cm.cmsTitle("search")%>
            <%=cm.cmsInput("search_btn")%>
          </td>
       </tr>
       <tr>
         <td>
           <jsp:include page="sites-databases.jsp" />
         </td>
       </tr>
    </table>
    </form>

          <%
            // Save search criteria
            if (SessionManager.isAuthenticated()&&SessionManager.isSave_search_criteria_RIGHT())
            {
          %>
              <br />
              <script type="text/javascript" language="JavaScript">
              <!--
              // values of source and database constants from specific class Domain(only in habitat searches, so here are all '')
              var source1='';
              var source2='';
              var database1='';
              var database2='';
              var database3='';
             //-->
             </script>
              <%=cm.cmsText("species_sites_19")%>:
              <a title="<%=cm.cms("save_title")%>" href="javascript:composeParameterListForSaveCriteria('<%=request.getParameter("expandSearchCriteria")%>',validateForm(),'species-sites.jsp','2','criteria',attributesNames,formFieldAttributes,operators,formFieldOperators,booleans,'save-criteria-search.jsp');"><img alt="<%=cm.cms("save_title")%>" border="0" src="images/save.jpg" width="21" height="19" style="vertical-align:middle" /></a>
              <%=cm.cmsTitle("save_title")%>
          <%
              // Set Vector for URL string
              Vector show = new Vector();
              show.addElement("showGroup");
              show.addElement("showOrder");
              show.addElement("showScientificName");
              show.addElement("showFamily");
              show.addElement("showOtherInfo");

              String pageName = "species-sites.jsp";
              String pageNameResult = "species-sites-result.jsp?"+Utilities.writeURLCriteriaSave(show);
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
<%=cm.cmsMsg("species_sites_19")%>
<%=cm.br()%>
<%=cm.cmsMsg("is")%>
<%=cm.br()%>
<%=cm.cmsMsg("starts")%>
<%=cm.br()%>
<%=cm.cmsMsg("contains")%>
<%=cm.br()%>
<%=cm.cmsMsg("greater")%>
<%=cm.br()%>
<%=cm.cmsMsg("smaller")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_20")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_21")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_22")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_title")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_08")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_09")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_10")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_11")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_12")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_13")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_14")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_sites_15")%>
<%=cm.br()%>

    <jsp:include page="footer.jsp">
      <jsp:param name="page_name" value="species-sites.jsp" />
    </jsp:include>
  </div>
  </div>
  </div>
  </body>
</html>