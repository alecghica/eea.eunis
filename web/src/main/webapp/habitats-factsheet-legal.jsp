<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Habitats legal instruments' function - display links to all habitat searches.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.WebContentManagement,
                 ro.finsiel.eunis.exceptions.InitializationException,
                 ro.finsiel.eunis.factsheet.habitats.HabitatsFactsheet,
                 ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalPersist" %>
<%@ page import="java.util.Vector"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// INPUT PARAMS: idHabitat
  String idHabitat = request.getParameter("idHabitat");
  // Mini factsheet shows only the uppermost part of the factsheet with generic information.
  HabitatsFactsheet factsheet = null;
  factsheet = new HabitatsFactsheet(idHabitat);
  WebContentManagement cm = SessionManager.getWebContent();
  Vector legals = null;
  try {
    legals = factsheet.getHabitatLegalInfo();
  } catch(InitializationException e) {
    e.printStackTrace();
  }
  // Habitat legal information.
  if((factsheet.isEunis() && !legals.isEmpty())) {
%>
<h2>
  <%=cm.cmsPhrase("Code in legal instrument")%>
</h2>
<table summary="<%=cm.cms("habitat_type_legal_instruments")%>" class="listing fullwidth">
  <thead>
    <tr>
      <th width="30%" style="text-align: left;">
        <%=cm.cmsPhrase("Legal Instrument")%>
      </th>
      <th width="50%" style="text-align: left;">
        <%=cm.cmsPhrase("Habitat type legal name")%>
      </th>
      <th width="20%" style="text-align: left;">
        <%=cm.cmsPhrase("Habitat type legal code")%>
      </th>
    </tr>
  </thead>
  <tbody>
<%
  for(int i = 0; i < legals.size(); i++)
  {
    HabitatLegalPersist legal = (HabitatLegalPersist) legals.get(i);
%>
    <tr>
      <td>
        <%=legal.getLegalName()%>
      </td>
      <td>
        <%=legal.getTitle()%>
      </td>
      <td>
        <%=legal.getCode()%>
      </td>
    </tr>
  <%
    }
  %>
    </tbody>
  </table>
  <%=cm.br()%>
  <%=cm.cmsMsg("habitat_type_legal_instruments")%>
<%
  }
%>
