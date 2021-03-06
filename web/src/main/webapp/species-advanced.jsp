<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species advanced search.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.sql.Connection,
                 java.sql.PreparedStatement,
                 java.sql.DriverManager,
                 java.sql.ResultSet,
                 ro.finsiel.eunis.search.advanced.SaveAdvancedSearchCriteria"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<html lang="<%=SessionManager.getCurrentLanguage()%>" xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=SessionManager.getCurrentLanguage()%>">
  <head>
  <jsp:include page="header-page.jsp" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  String eeaHome = application.getInitParameter( "EEA_HOME" );
  String btrail = "eea#" + eeaHome + ",home#index.jsp,species#species.jsp,advanced_search";
%>
<title>
  <%=application.getInitParameter("PAGE_TITLE")%>
  <%=request.getParameter("natureobject")!=null?request.getParameter("natureobject"):""%> <%=cm.cms("advanced_search")%>
</title>
<script language="JavaScript" type="text/javascript">
//<![CDATA[
  var current_selected="";
//]]>
</script>

<script language="JavaScript" type="text/javascript">
//<![CDATA[
  function MM_jumpMenu(targ,selObj,restore){ //v3.0
    eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
    if (restore) selObj.selectedIndex=0;
  }

  function setCurrentSelected(val) {
    current_selected = val;
    return true;
  }

  function choice(ctl, lov, natureobject, oper) {
    var cur_ctl = "window.document.criteria['"+ctl+"'].value";
    var val = eval(cur_ctl);
    URL = 'advanced-search-lov.jsp' + '?ctl=' + ctl + '&lov=' + lov + '&natureobject=' + natureobject + '&val=' + val + '&oper=' + oper;
    eval("page = window.open(URL, '', 'scrollbars=yes,toolbar=0, resizable=yes, location=0,width=400,height=500,left=490,top=0');");
  }

  function getkey(e)
  {
    if (window.event)
       return window.event.keyCode;
    else if (e)
       return e.which;
    else
       return null;
  }

  function textChanged(e)
  {
    var key, keychar;
    key = getkey(e);
    if (key == null) return true;

    // get character
    keychar = String.fromCharCode(key);
    keychar = keychar.toLowerCase();

    // control keys
    if ( key==null || key==0 || key==8 || key==9 || key==13 || key==27 ) {
      return false;
    }

    enableSaveButton();
    return true;
  }

  // action specifies what to do (how to modify the submited url...
  function submitCriteriaForm(criteria, idnode) {
    document.criteria.criteria.value=criteria.value;
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function enableSaveButton() {
    document.criteria.Save.disabled=false;
    document.criteria.Search.disabled=true;
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=cm.cms("press_save_to_save_criteria")%></span>"
  }

  function disableSaveButton() {
    document.criteria.Save.disabled=true;
    document.criteria.Search.disabled=false;
    document.getElementById("status").innerHTML="<span style=\"color:red;\"><%=cm.cms("criteria_saved")%></span>"
  }

  function submitAttributeForm(attribute, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value=attribute.value;
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitOperatorForm(operator, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value=operator.value;
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    document.criteria.submit();
  }

  function submitFirstValueForm(firstvalue, idnode) {
    if(firstvalue.value == "") {
      firstvalue.value = document.criteria.oldfirstvalue.value;
      alert('<%=cm.cmsPhrase("Previous values were restored")%>');
      firstvalue.focus();
		  return(false);
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value=firstvalue.value;
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var ofv = document.criteria.oldfirstvalue.value;
    var fv = document.criteria.firstvalue.value;
    if(ofv != fv) {
      if(current_selected == "first_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("First_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitLastValueForm(lastvalue, idnode) {
    if(lastvalue.value == "") {
      lastvalue.value = document.criteria.oldlastvalue.value;
      alert('<%=cm.cmsPhrase("Previous values were restored")%>');
      firstvalue.focus();
		  return false;
    }

    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value=lastvalue.value;
    document.criteria.idnode.value=idnode;
    document.criteria.action.value="";
    var olv = document.criteria.oldlastvalue.value;
    var lv = document.criteria.lastvalue.value;
    if(olv != lv) {
      if(current_selected == "last_binocular") {
        var lov="";
        var natureobject="<%=request.getParameter("natureobject")%>";
        var oper="";
        lov = eval("window.document.criteria['Attribute"+idnode+"'].value");
        choice("Last_Value"+idnode, lov, natureobject, oper);
      }
      document.criteria.submit();
    }
  }

  function submitButtonForm(action, idnode) {
    document.criteria.criteria.value="";
    document.criteria.attribute.value="";
    document.criteria.operator.value="";
    document.criteria.firstvalue.value="";
    document.criteria.lastvalue.value="";
    document.criteria.idnode.value=idnode;
    document.criteria.action.value=action;
    document.criteria.submit();
  }

  function saveFirstValue(val) {
    document.criteria.oldfirstvalue.value=val.value;
  }

  function saveLastValue(val) {
    document.criteria.oldlastvalue.value=val.value;
  }

  function SaveCriteriaFunction() {

  var URL2 = "save-species-or-habitats-advanced-search-criteria.jsp?";
  URL2 += "&idsession="+document.saveCriteriaSearch.idsession.value;
  URL2 += "&natureobject="+document.saveCriteriaSearch.natureobject.value;
  URL2 += "&username="+document.saveCriteriaSearch.username.value;
  URL2 += "&fromWhere="+document.saveCriteriaSearch.fromWhere.value;
  URL2 += "&saveThisCriteria=false";

  eval("page = window.open(URL2, '', 'scrollbars=yes,toolbar=0,location=0,width=400,height=500,left=490,top=80');");
  }

function setFormLoadSaveCriteria(fromWhere,criterianame,natureobject) {
      document.loadSaveCriteria.fromWhere.value = fromWhere;
      document.loadSaveCriteria.criterianame.value = criterianame;
      document.loadSaveCriteria.natureobject.value = natureobject;

      document.loadSaveCriteria.submit();
   }

function setFormDeleteSaveCriteria(fromWhere,criterianame,natureobject) {
      document.deleteSaveCriteria.fromWhere.value = fromWhere;
      document.deleteSaveCriteria.criterianame.value = criterianame;
      document.deleteSaveCriteria.natureobject.value = natureobject;

      document.deleteSaveCriteria.submit();
   }
//]]>
</script>

<%
  String IdSession = request.getParameter("idsession");
  String NatureObject = request.getParameter("natureobject");
  if(IdSession == null || IdSession.length()==0 || IdSession.equalsIgnoreCase("undefined")) {
    IdSession=request.getSession().getId();
  }
  if(NatureObject == null || NatureObject.length()==0 || NatureObject.equalsIgnoreCase("undefined")) {
    NatureObject="Species";
  }
  // Load saved search
  if(request.getParameter("loadCriteria") != null && request.getParameter("loadCriteria").equalsIgnoreCase("yes"))
  {
	  String rfw = (String)request.getParameter("fromWhere");
	  String rcn = (String)request.getParameter("criterianame");
	  String rsn = (String)request.getParameter("siteName");
%>
     <jsp:include page="load-save-criteria.jsp">
       <jsp:param name="fromWhere" value="<%=rfw%>"/>
  	   <jsp:param name="criterianame" value="<%=rcn%>"/>
  	   <jsp:param name="siteName" value="<%=rsn%>"/>
       <jsp:param name="natureobject" value="<%=NatureObject%>"/>
       <jsp:param name="idsession" value="<%=IdSession%>"/>
     </jsp:include>
<%
  }
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
                  <jsp:param name="location" value="<%=btrail%>"/>
                </jsp:include>
                <a name="documentContent"></a>
                <h1><%=cm.cmsPhrase("Species advanced search")%></h1>
                <div class="documentActions">
                  <h5 class="hiddenStructure"><%=cm.cmsPhrase("Document Actions")%></h5>
                  <ul>
                    <li>
                      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif" alt="<%=cm.cmsPhrase("Print this page")%>" title="<%=cm.cmsPhrase("Print this page")%>" /></a>
                    </li>
                    <li>
                      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif" alt="<%=cm.cmsPhrase("Toggle full screen mode")%>" title="<%=cm.cmsPhrase("Toggle full screen mode")%>" /></a>
                    </li>
                  </ul>
                </div>
<!-- MAIN CONTENT -->
                <%=cm.cmsPhrase("Search species information using multiple characteristics")%>
                <br />
                <br />
                <table summary="layout" border="0">
                  <tr>
                    <td id="status">
                      <%=cm.cmsPhrase("Specify the search criteria:")%>
                    </td>
                  </tr>
                </table>
            <%
              String listcriteria="";
              String explainedcriteria="";
            %>
            <form method="post" action="species-advanced.jsp" name="criteria" id="criteria">
            <input type="hidden" name="criteria" value="" />
            <input type="hidden" name="attribute" value="" />
            <input type="hidden" name="operator" value="" />
            <input type="hidden" name="firstvalue" value="" />
            <input type="hidden" name="lastvalue" value="" />
            <input type="hidden" name="oldfirstvalue" value="" />
            <input type="hidden" name="oldlastvalue" value="" />
            <input type="hidden" name="action" value="" />
            <input type="hidden" name="idnode" value="" />
            <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
            <input type="hidden" name="idsession" value="<%=IdSession%>" />
            <%
//  System.out.println("NatureObject = " + NatureObject);
//  System.out.println("IdSession = " + IdSession);
              int SQL_LIMIT = Integer.parseInt(application.getInitParameter("SQL_LIMIT"));

              String SQL_DRV = application.getInitParameter("JDBC_DRV");
              String SQL_URL = application.getInitParameter("JDBC_URL");
              String SQL_USR = application.getInitParameter("JDBC_USR");
              String SQL_PWD = application.getInitParameter("JDBC_PWD");

              //Utilities.dumpRequestParams(request);
              String p_action = request.getParameter("action");
              if(p_action==null) p_action="";
              String p_idnode = request.getParameter("idnode");
              if(p_idnode==null) p_idnode="";
              String p_criteria = request.getParameter("criteria");
              if(p_criteria==null) p_criteria="";
              String p_attribute = request.getParameter("attribute");
              if(p_attribute==null) p_attribute="";
              String p_operator = request.getParameter("operator");
              if(p_operator==null) p_operator="";
              String p_firstvalue = request.getParameter("firstvalue");
              if(p_firstvalue==null) p_firstvalue="";
              String p_lastvalue = request.getParameter("lastvalue");
              if(p_lastvalue==null) p_lastvalue="";
              //System.out.println(requestURL);

              ro.finsiel.eunis.search.AdvancedSearch tas = new ro.finsiel.eunis.search.AdvancedSearch();
              tas.SetSQLLimit(SQL_LIMIT);

              tas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);

              //prelucram actiunea curenta
              if(p_action.equalsIgnoreCase("reset")) {
                ro.finsiel.eunis.search.AdvancedSearch tsas;
                tsas = new ro.finsiel.eunis.search.AdvancedSearch();
                tsas.SetSQLLimit(SQL_LIMIT);
                tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                String attribute="ScientificName";
                if(NatureObject.equalsIgnoreCase("Sites")) {
                  attribute="Name";
                }
                tsas.DeleteRoot(IdSession,NatureObject,attribute);
              }

              if(p_action.equalsIgnoreCase("deleteroot")) {
                //out.println("Delete root");
                String attribute="ScientificName";
                if(NatureObject.equalsIgnoreCase("Sites")) {
                  attribute="Name";
                }
                if(!tas.DeleteRootNoInitialize(IdSession,NatureObject,attribute)) {
                  System.out.println("Error deleting root!");
                  %>
                    <script language="JavaScript" type="text/javascript">
                    //<![CDATA[
                      alert('<%=cm.cms("error_deleting_root")%>');
                    //]]>
                    </script>
                  <%
                }
              }

              if(p_action.equalsIgnoreCase("addroot")) {
                //out.println("Add root");
                String attribute="ScientificName";
                if(NatureObject.equalsIgnoreCase("Sites")) {
                  attribute="Name";
                }
                //System.out.println("attribute = " + attribute);
                tas.CreateInitialBranch(IdSession,NatureObject,attribute);
              }

              if(p_action.equalsIgnoreCase("add")) {
                //out.println("Add branch for node: "+p_idnode);
                String attribute="ScientificName";
                if(NatureObject.equalsIgnoreCase("Sites")) {
                  attribute="Name";
                }
                if(!tas.InsertBranch(p_idnode,IdSession,NatureObject,attribute)) {
                 System.out.println("Error adding branch!");
                 %>
                   <script language="JavaScript" type="text/javascript">
                   //<![CDATA[
                     alert('<%=cm.cms("error_adding_branch")%>');
                   //]]>
                   </script>
                 <%
                }
              }

              if(p_action.equalsIgnoreCase("delete")) {
                //out.println("Delete branch for node: "+p_idnode);
                if(!tas.DeleteBranch(p_idnode,IdSession,NatureObject)) {
                 System.out.println("Error deleting branch!");
                 %>
                   <script language="JavaScript" type="text/javascript">
                   //<![CDATA[
                     alert('<%=cm.cms("error_deleting_branch")%>');
                   //]]>
                   </script>
                 <%
                }
              }

              if(p_action.equalsIgnoreCase("compose")) {
                //out.println("Compose branch for node: "+p_idnode);
                if(!tas.ComposeBranch(p_idnode,IdSession,NatureObject)) {
                 System.out.println("Error composing branch!");
                 %>
                   <script language="JavaScript" type="text/javascript">
                   //<![CDATA[
                     alert('<%=cm.cms("error_composing_branch")%>');
                   //]]>
                   </script>
                 <%
                }
              }

              if(p_action.length()==0) {
                if(p_criteria.length() != 0) {
                  //out.println("New criteria: "+p_criteria+" for node: "+p_idnode);
                  tas.ChangeCriteria(p_idnode,IdSession,NatureObject,p_criteria);
                }
                if(p_attribute.length() != 0) {
                  //out.println("New attribute: "+p_attribute+" for node: "+p_idnode);
                  tas.ChangeAttribute(p_idnode,IdSession,NatureObject,p_attribute);
                }
                if(p_operator.length() != 0) {
                  //out.println("New operator: "+p_operator+" for node: "+p_idnode);
                  tas.ChangeOperator(p_idnode,IdSession,NatureObject,p_operator);
                }
                if(p_firstvalue.length() != 0) {
                  //out.println("New first value: "+p_firstvalue+" for node: "+p_idnode);
                  //System.out.println("first value:" + p_firstvalue);
                  tas.ChangeFirstValue(p_idnode,IdSession,NatureObject,p_firstvalue);
                }
                if(p_lastvalue.length() != 0) {
                  //out.println("New last value: "+p_lastvalue+" for node: "+p_idnode);
                  //System.out.println("last value:" + p_lastvalue);
                  tas.ChangeLastValue(p_idnode,IdSession,NatureObject,p_lastvalue);
                }
              }

              String SQL="";
              String NodeType="";
              String IdNode="";
              String val="";
              String selected="";
              String currentAttribute="";
              String currentOperator="";
              String currentValue="";

              Connection con = null;
              PreparedStatement ps = null;
              ResultSet rs =null;

              try {
                Class.forName(SQL_DRV);
                con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
              }
              catch(Exception e) {
                e.printStackTrace();
                return;
              }

              SQL="SELECT ";
              SQL+="EUNIS_ADVANCED_SEARCH.ID_NODE,";
              SQL+="EUNIS_ADVANCED_SEARCH.NODE_TYPE,";
              SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.ATTRIBUTE,";
              SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.OPERATOR,";
              SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.FIRST_VALUE,";
              SQL+="EUNIS_ADVANCED_SEARCH_CRITERIA.LAST_VALUE ";
              SQL+="FROM ";
              SQL+="EUNIS_ADVANCED_SEARCH ";
              SQL+="LEFT OUTER JOIN EUNIS_ADVANCED_SEARCH_CRITERIA ON (EUNIS_ADVANCED_SEARCH.ID_SESSION = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_SESSION) AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT = EUNIS_ADVANCED_SEARCH_CRITERIA.NATURE_OBJECT) AND (EUNIS_ADVANCED_SEARCH.ID_NODE = EUNIS_ADVANCED_SEARCH_CRITERIA.ID_NODE) ";
              SQL+="WHERE (EUNIS_ADVANCED_SEARCH.ID_SESSION='"+IdSession+"') ";
              SQL+="AND (EUNIS_ADVANCED_SEARCH.NATURE_OBJECT='"+NatureObject+"') ";
              SQL+="ORDER BY ";
              SQL+="EUNIS_ADVANCED_SEARCH.ID_NODE ";

              ps = con.prepareStatement(SQL);
              rs = ps.executeQuery();
              if(rs.isBeforeFirst()){
              //if(1==1){
                while(rs.next()) {
                  IdNode=rs.getString("ID_NODE");
                  NodeType=rs.getString("NODE_TYPE");
                  if(!IdNode.equalsIgnoreCase("0")) {
                    out.println("&nbsp;");out.println("&nbsp;");
                  }
                  for(int i=1;i<=IdNode.length()*3;i++) {
                    if(!IdNode.equalsIgnoreCase("0")) {
                      out.println("&nbsp;");
                    }
                  }

                  if(!IdNode.equalsIgnoreCase("0")) {
                    if(IdNode.length()<=3) {
                      %>
                      <a title="<%=cm.cms("add_criterion")%>" href="javascript:submitButtonForm('add','<%=IdNode%>');"><img border="0" src="images/mini/add.gif" width="13" height="13" alt="<%=cm.cms("add_criterion")%>" title="<%=cm.cms("add_criterion")%>" /></a><%=cm.cmsTitle("add_criterion")%>
                      <%
                    }
                    if(IdNode.equalsIgnoreCase("1")) {
                      %>
                      <img border="0" alt="" src="images/mini/space.gif" />
                      <%
                    } else {
                    %>
                      <a title="<%=cm.cms("delete_criterion")%>" href="javascript:submitButtonForm('delete','<%=IdNode%>');"><img border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_criterion")%>" alt="<%=cm.cms("delete_criterion")%>" /></a><%=cm.cmsTitle("delete_criterion")%>
                    <%
                    }

                    if(IdNode.length() < 3) {
                      if(NodeType.equalsIgnoreCase("Criteria")) {
                      %>
                        <a title="<%=cm.cms("compose_criterion")%>" href="javascript:submitButtonForm('compose','<%=IdNode%>');"><img alt="<%=cm.cms("compose_criterion")%>" border="0" src="images/mini/compose.gif" width="13" height="13" title="<%=cm.cms("compose_criterion")%>" /></a><%=cm.cmsTitle("compose_criterion")%>
                      <%
                      }
                    }
                    out.println("&nbsp;"+IdNode);
                  } else {
                    %>
                    <a title="<%=cm.cms("delete_root_criterion")%>" href="javascript:submitButtonForm('deleteroot','<%=IdNode%>');"><img alt="<%=cm.cms("delete_root_criterion")%>" border="0" src="images/mini/delete.gif" width="13" height="13" title="<%=cm.cms("delete_root_criterion")%>" /></a><%=cm.cmsTitle("delete_root_criterion")%>
                    <%
                  }

                  String cmsCriteria = cm.cmsPhrase("Criteria");
                  String cmsAttribute = cm.cms("advanced_attribute");
                  String cmsOperator = cm.cmsPhrase("Operator");
                  String cmsAll = cm.cms("all");
                  String cmsAny = cm.cms("any");
                  String cmsFollowingCriteria = cm.cms("of_following_criteria_are_met");

                  if (!NodeType.equalsIgnoreCase("Criteria")) {
                    out.println("<label for=\"Criteria" + IdNode + "\" class=\"noshow\">"+cmsCriteria+"</label>");
                    out.println("<select name=\"Criteria" + IdNode + "\" onchange=\"submitCriteriaForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsCriteria+"\" id=\"Criteria"+ IdNode + "\">");
                    if (NodeType.equalsIgnoreCase("All")) {
                      selected = " selected=\"selected\"";
                    } else {
                      selected = "";
                    }
                    out.println("<option" + selected + " value=\"All\">"+cmsAll+"</option>");
                    if (NodeType.equalsIgnoreCase("Any")) {
                      selected = " selected=\"selected\"";
                    } else {
                      selected = "";
                    }
                    out.println("<option" + selected + " value=\"Any\">"+cmsAny+"</option>");
                    out.println("</select> " + cmsFollowingCriteria + ":");
                    out.println("<br />");
                  } else {
                    val = rs.getString("ATTRIBUTE");
                    currentAttribute = val;
                    out.println("<label for=\"Attribute" + IdNode + "\" class=\"noshow\">"+cmsAttribute+"</label>");
                    out.println("<select name=\"Attribute" + IdNode + "\" onchange=\"submitAttributeForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsAttribute+"\" id=\"Attribute" + IdNode + "\">");

                    if(NatureObject.equalsIgnoreCase("Species")) {
                      if(val.equalsIgnoreCase("ScientificName")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"ScientificName\">"+cm.cmsPhrase("Scientific name")+"</option>");
                      if(val.equalsIgnoreCase("VernacularName")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"VernacularName\">"+cm.cms("vernacular_name")+"</option>");
                      if(val.equalsIgnoreCase("Group")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Group\">"+cm.cmsPhrase("Group")+"</option>");
                      if(val.equalsIgnoreCase("ThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"ThreatStatus\">"+cm.cms("threat_status")+"</option>");
                      if(val.equalsIgnoreCase("InternationalThreatStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"InternationalThreatStatus\">"+cm.cms("international_threat_status")+"</option>");
                      if(val.equalsIgnoreCase("Country")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Country\">"+cm.cmsPhrase("Country")+"</option>");
                      if(val.equalsIgnoreCase("Biogeoregion")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Biogeoregion\">"+cm.cms("biogeoregion")+"</option>");
                      if(val.equalsIgnoreCase("Author")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Author\">"+cm.cms("reference_author")+"</option>");
                      if(val.equalsIgnoreCase("Title")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Title\">"+cm.cms("reference_title")+"</option>");
                      if(val.equalsIgnoreCase("LegalInstrument")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"LegalInstrument\">"+cm.cms("species_advanced_19")+"</option>");
                      if(val.equalsIgnoreCase("Taxonomy")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Taxonomy\">"+cm.cms("taxonomy")+"</option>");
                      if(val.equalsIgnoreCase("Abundance")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Abundance\">"+cm.cms("abundance")+"</option>");
                      if(val.equalsIgnoreCase("Trend")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"Trend\">"+cm.cms("trend")+"</option>");
                      if(val.equalsIgnoreCase("DistributionStatus")) { selected=" selected=\"selected\""; } else { selected=""; }
                      out.println("<option"+selected+" value=\"DistributionStatus\">"+cm.cms("distribution_status")+"</option>");
                    }
                    out.println("</select>");
                    %>
                    <%=cm.cmsInput("vernacular_name")%>
                    <%=cm.cmsInput("threat_status")%>
                    <%=cm.cmsInput("international_threat_status")%>
                    <%=cm.cmsInput("biogeoregion")%>
                    <%=cm.cmsInput("reference_author")%>
                    <%=cm.cmsInput("reference_title")%>
                    <%=cm.cmsInput("species_advanced_19")%>
                    <%=cm.cmsInput("taxonomy")%>
                    <%=cm.cmsInput("abundance")%>
                    <%=cm.cmsInput("trend")%>
                    <%=cm.cmsInput("distribution_status")%>
                    <%
                    out.println("&nbsp;");

                    val=rs.getString("OPERATOR");
                    currentOperator = val;
                    out.println("<label for=\"Operator" + IdNode + "\" class=\"noshow\">"+cmsOperator+"</label>");
                    out.println("<select name=\"Operator" + IdNode + "\" onchange=\"submitOperatorForm(this,'" + IdNode + "','" + IdSession + "','" + NatureObject + "')\" title=\""+cmsOperator+"\" id=\"Operator" + IdNode + "\">");

                    if(val.equalsIgnoreCase("Equal")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Equal\">"+cm.cms("equal")+"</option>");
                    if(val.equalsIgnoreCase("Contains")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Contains\">"+cm.cmsPhrase("Contains")+"</option>");
                    if(val.equalsIgnoreCase("Between")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Between\">"+cm.cmsPhrase("Between")+"</option>");
                    if(val.equalsIgnoreCase("Regex")) { selected=" selected=\"selected\""; } else { selected=""; }
                    out.println("<option"+selected+" value=\"Regex\">Regex</option>");
                    out.println("</select>");
                    %>
                    <%=cm.cmsInput("equal")%>
                    <%
                    out.println("&nbsp;");

                    val=rs.getString("FIRST_VALUE");
                    currentValue = val;
                    %>
                    <label for="First_Value<%=IdNode%>" class="noshow"><%=cm.cmsPhrase("List of values")%></label>
                    <input type="text" title="<%=cm.cmsPhrase("List of values")%>" name="First_Value<%=IdNode%>" id="First_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitFirstValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>');" onfocus="saveFirstValue(this)" onkeyup="textChanged(event)" />
                    <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:choice('First_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="first_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cmsPhrase("List of values")%>" /></a>
                    <%
                    if(rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
                      out.println(cm.cmsPhrase("and"));
                      val=rs.getString("LAST_VALUE");
                      currentValue = val;
                      %>
                      <label for="Last_Value<%=IdNode%>" class="noshow"><%=cm.cmsPhrase("List of values")%></label>
                      <input type="text" title="<%=cm.cmsPhrase("List of values")%>" name="Last_Value<%=IdNode%>" id="Last_Value<%=IdNode%>" size="25" value="<%=val%>" onblur="submitLastValueForm(this,'<%=IdNode%>','<%=IdSession%>','<%=NatureObject%>')" onfocus="saveLastValue(this)" onkeyup="textChanged(event)" />
                      <a title="<%=cm.cmsPhrase("List of values")%>" href="javascript:choice('Last_Value<%=IdNode%>','<%=currentAttribute%>','<%=NatureObject%>','<%=currentOperator%>')" name="last_binocular"  onmouseover="setCurrentSelected(this.name)" onmouseout="setCurrentSelected('')"><img border="0" src="images/helper/helper.gif" width="11" height="18" alt="<%=cm.cmsPhrase("List of values")%>" /></a>
                      <%
                    }
                    %>
                    <br />
                    <%
                  }
                }
                %>
                <br />
                <input type="button" class="saveButton" onclick="disableSaveButton()" disabled="disabled" value="Save" id="Save" name="Save" title="<%=cm.cmsPhrase("Save")%>" />
                &nbsp;&nbsp;&nbsp;
                <input type="submit" class="submitSearchButton" value="Search" id="Search" name="Search" title="<%=cm.cmsPhrase("Search")%>" />
                &nbsp;&nbsp;&nbsp;
                <input type="button" class="standardButton" onclick="submitButtonForm('reset','0')" value="Reset" id="Reset" name="Reset" title="<%=cm.cmsPhrase("Reset")%>" />
                <%
              } else {
                %>
                <a title="<%=cm.cms("add_root")%>" href="javascript:submitButtonForm('addroot','0');"><img border="0" src="images/mini/add.gif" width="13" height="13" title="<%=cm.cms("add_root")%>" alt="<%=cm.cms("add_root")%>" /></a>&nbsp;<%=cm.cmsPhrase("Add root criterion")%>
                <%
              }

              rs.close();
              %>
              </form>
              <br />
              <strong><%=cm.cmsPhrase("Note: Advanced search might take a long time")%></strong>
              <br />
              <%

              String criteria=tas.createCriteria(IdSession,NatureObject);
              out.println(cm.cms("calculated_criteria"));
              explainedcriteria=criteria.replace('#',' ').replace('[','(').replace(']',')').replaceAll("AND","<strong>AND</strong>").replaceAll("OR","<strong>OR</strong>");
              out.println(explainedcriteria);

              out.println("<br />");
              out.println("<br />");
              out.flush();

              if(request.getParameter("Search")!=null) {
                String finalwhere="";
                String node="";
                int pos_start=-1;
                int pos_end=-1;
                String interpretedcriteria="";
                String intermediatefilter="";

                if(NatureObject.equalsIgnoreCase("Species")) {
                  ro.finsiel.eunis.search.AdvancedSearch tsas;
                  tsas = new ro.finsiel.eunis.search.AdvancedSearch();
                  tsas.SetSQLLimit(SQL_LIMIT);
                  tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                  pos_start=criteria.indexOf('#');
                  pos_end=criteria.indexOf('#',pos_start+1);
                  while(pos_start!=-1 && pos_end!=-1) {
                    node=criteria.substring(pos_start+1,pos_end);
                    interpretedcriteria=tsas.InterpretCriteria(node,IdSession,NatureObject);
                    //add criteria to the list of criteria passed to the results page
                    listcriteria+=node+": "+interpretedcriteria+"<br />";
                    out.println(cm.cmsPhrase("Searching for: {0}...",interpretedcriteria));
                    out.flush();
                    intermediatefilter=tsas.BuildFilter(node,IdSession,NatureObject);
                    out.println(cm.cmsPhrase("found: <strong>{0}</strong>",tsas.getResultCount()));
                    if(tsas.getResultCount()>=SQL_LIMIT) {
                      out.println("<br />&nbsp;&nbsp;(" + cm.cmsPhrase("Only first") + " "+SQL_LIMIT + " " + cm.cmsPhrase("results were retrieved - this can lead to partial,incomplete or no combined search results at all - you should refine this criteria") + ")");
                    }
                    out.println("<br />");
                    out.flush();

                    finalwhere="";
                    finalwhere+=criteria.substring(0,pos_start);
                    finalwhere+="ID_NATURE_OBJECT IN ("+intermediatefilter+")";
                    finalwhere+=criteria.substring(pos_end+1);
                    criteria=finalwhere;

                    pos_start=criteria.indexOf('#',pos_end+1);
                    if(pos_start!=-1) {
                      pos_end=criteria.indexOf('#',pos_start+1);
                    } else {
                    }
                  }
                }

                //System.out.println("Starting final search...");
                ro.finsiel.eunis.search.AdvancedSearch tsas;
                tsas = new ro.finsiel.eunis.search.AdvancedSearch();
                tsas.SetSQLLimit(SQL_LIMIT);
                tsas.Init(SQL_DRV,SQL_URL,SQL_USR,SQL_PWD);
                String str=tsas.calculateCriteria(IdSession,NatureObject);

                tsas.DeleteResults(IdSession,NatureObject);

                str="SELECT ID_NATURE_OBJECT FROM CHM62EDT_"+NatureObject.toUpperCase()+" WHERE ("+str+")";
                String query = tsas.ExecuteFilterSQL(str,"");
                out.println("<br /><strong>" + cm.cmsPhrase("Total species matching your combined criteria found in database:") + "  " + tsas.getResultCount() + "</strong><br />");
                out.flush();

                if (tsas.getResultCount() > 0) {
                  tsas.AddResult(IdSession,NatureObject,query);
                }

                if (tsas.getResultCount() > 0) {
                %>
                <form name="search" action="select-columns.jsp" method="post">
                  <input type="submit" id="NextStep" name="<%=cm.cms("proceed_to_next_step")%>" value="<%=cm.cms("proceed_to_next_step")%>" title="<%=cm.cms("proceed_to_next_step")%>" class="submitSearchButton" />
                  <%=cm.cmsInput("proceed_to_next_step")%>
                  <input type="hidden" name="searchedNatureObject" value="Species" />
                  <input type="hidden" name="origin" value="Advanced" />
                  <input type="hidden" name="explainedcriteria" value="<%=explainedcriteria%>" />
                  <input type="hidden" name="listcriteria" value="<%=listcriteria%>" />
                </form>
                <%
                  // Save this advanced search
                  if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
                  {
                %>
                <br />
                <br />
                <table summary="layout" width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td>
                    <form name="saveCriteriaSearch" action="save-species-or-habitats-advanced-search-criteria.jsp" method="post">
                      <label for="SaveCriteria" class="noshow"><%=cm.cmsPhrase("Save search criteria")%></label>
                      <input type="button" id="SaveCriteria" name="Save Criteria" title="<%=cm.cmsPhrase("Save search criteria")%>" value="<%=cm.cmsPhrase("Save search criteria")%>"
                             class="standardButton" onClick="javascript:SaveCriteriaFunction();" />
                      <input type="hidden" name="idsession" value="<%=IdSession%>" />
                      <input type="hidden" name="natureobject" value="<%=NatureObject%>" />
                      <input type="hidden" name="username" value="<%=SessionManager.getUsername()%>" />
                      <input type="hidden" name="fromWhere" value="species-advanced.jsp" />
                    </form>
                 </td>
               </tr>
               </table>
                <%
                  }
                %>
                <%
                } else {
                %>
                   <br /><%=cm.cmsPhrase("No results were found matching your combined criteria.")%><br />
                <%
                }
              }
              con.close();
              // Expand saved advanced searches list for this jsp page
              if (SessionManager.isAuthenticated() && SessionManager.isSave_search_criteria_RIGHT())
              {
                String exp = (request.getParameter("expandCriterias") == null ? "no" : request.getParameter("expandCriterias"));
            %>
                <br />
                <br />
                <table summary="layout" width="100%" border="0">
                  <tr>
                    <td>
                      <img border="0" alt="<%=cm.cms("advanced_expand_collapse")%>" style="vertical-align:middle" src="images/mini/<%=(exp.equals("yes")?"collapse.gif":"expand.gif")%>" /><a title="<%=cm.cms("advanced_expand_collapse")%>" href="species-advanced.jsp?expandCriterias=<%=(exp.equals("yes")?"no":"yes")%>"><%=(exp.equalsIgnoreCase("yes") ? cm.cms("hide") : cm.cms("show"))%> <%=cm.cmsPhrase("Saved search criteria")%></a>
                      <%=cm.cmsTitle("advanced_expand_collapse")%>
                      <%=cm.cmsTitle("hide")%>
                      <%=cm.cmsTitle("show")%>
                      <%=cm.cmsTitle("hide")%>
                      <%=cm.cmsTitle("show")%>
                    </td>
                  </tr>
                </table>
              <%
                // If list is expanded
                if (exp !=null && exp.equals("yes"))
                {
              %>
                  <form name="loadSaveCriteria" method="post" action="species-advanced.jsp">
                    <input type ="hidden" name="loadCriteria" value="yes" />
                    <input type ="hidden" name="fromWhere" value="" />
                    <input type ="hidden" name="criterianame" value="" />
                    <input type ="hidden" name="natureobject" value="" />
                    <input type ="hidden" name="expandCriterias" value="yes" />
                  </form>

                  <form name="deleteSaveCriteria" method="post" action="delete-save-advanced-search-criteria.jsp">
                    <input type ="hidden" name="fromWhere" value="" />
                    <input type ="hidden" name="criterianame" value="" />
                    <input type ="hidden" name="natureobject" value="" />
                  </form>

              <%  // list of saved searches
                  out.print(SaveAdvancedSearchCriteria.ExpandSaveCriteriaForThisPage(SQL_DRV,
                                                                                    SQL_URL,
                                                                                    SQL_USR,
                                                                                    SQL_PWD,
                                                                                    SessionManager.getUsername(),
                                                                                    "species-advanced.jsp"));
                }
              }
            %>
            <%=cm.br()%>
            <%=cm.cmsMsg("advanced_search")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("press_save_to_save_criteria")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("criteria_saved")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("advanced_search")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("error_deleting_root")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("error_adding_branch")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("error_deleting_branch")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("advanced_attribute")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("all")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("any")%>
            <%=cm.br()%>
            <%=cm.cmsMsg("of_following_criteria_are_met")%>
<!-- END MAIN CONTENT -->
              </div>
            </div>
          </div>
          <!-- end of main content block -->
          <!-- start of the left (by default at least) column -->
          <div id="portal-column-one">
            <div class="visualPadding">
              <jsp:include page="inc_column_left.jsp">
                <jsp:param name="page_name" value="species-advanced.jsp" />
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
