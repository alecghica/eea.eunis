<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - vernacular names.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.species.VernacularNameWrapper,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
  <jsp:setProperty name="FormBean" property="*"/>
</jsp:useBean>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session"/>
<%
  WebContentManagement cm = SessionManager.getWebContent();
  Integer idNatureObject = Utilities.checkedStringToInt( request.getParameter( "idNatureObject" ), new Integer( 0 ) );
  // List of vernacular names for a given species
  List results = SpeciesSearchUtility.findVernacularNames( idNatureObject );
  Iterator it = results.iterator();
  if ( !results.isEmpty() )
  {
%>
  <h2>
    <%=cm.cmsPhrase("Vernacular names")%>
  </h2>
  <table summary="<%=cm.cms("vernacular_names")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Vernacular Name")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Language")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Reference")%>
          <%=cm.cmsTitle("sort_results_on_this_column")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    int i = 0;
    while (it.hasNext())
    {
      String cssClass = i++ % 2 == 0 ? "zebraodd" : "zebraeven";
      VernacularNameWrapper vName = ( ( VernacularNameWrapper ) it.next() );
      String reference = ( vName.getIdDc() == null ? "-1" : vName.getIdDc().toString() );
%>
      <tr class="<%=cssClass%>">
        <td xml:lang="<%=vName.getLanguageCode() %>">
          <%=Utilities.treatURLSpecialCharacters(vName.getName())%>
        </td>
        <td>
          <%=vName.getLanguage()%>
        </td>
<%
        String ref = Utilities.getReferencesByIdDc( reference );
        Vector authorURL = Utilities.getAuthorAndUrlByIdDc( reference );
%>
        <td>
              <a class="link-plain" href="documents/<%=reference%>"><%=Utilities.treatURLSpecialCharacters((String)authorURL.get(0))%></a>
        </td>
      </tr>
<%
    }
%>
    </tbody>
  </table>
<%
  }
%>
<%=cm.br()%>
<%=cm.cmsMsg("vernacular_names")%>
  <br />