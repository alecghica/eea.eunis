<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Species factsheet - legal informations.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement,
                 java.util.Vector,
                 ro.finsiel.eunis.factsheet.species.LegalStatusWrapper"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  /// Request parameters:
  // idSpecies - ID of species
  String mainIdSpecies = request.getParameter("mainIdSpecies");
  SpeciesFactsheet factsheet = new SpeciesFactsheet(
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)),
		  Utilities.checkedStringToInt(mainIdSpecies, new Integer(0)));
  WebContentManagement cm = SessionManager.getWebContent();

  // Species legal instruments
  Vector legals = factsheet.getLegalStatus();
  if (legals.size() > 0)
  {
%>
  <h2>
    <%=cm.cmsPhrase("Legal Instruments")%>
  </h2>
  <table summary="<%=cm.cms("species_factsheet_legalInstruments_01_Sum")%>" class="listing fullwidth">
    <thead>
      <tr>
        <th scope="col">
          <%=cm.cmsPhrase("Detailed reference")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Legal text")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Comments")%>
        </th>
        <th scope="col">
          <%=cm.cmsPhrase("Url")%>
        </th>
      </tr>
    </thead>
    <tbody>
<%
    for (int i = 0; i < legals.size(); i++)
    {
      String cssClass = i % 2 == 0 ? "zebraodd" : "zebraeven";
      LegalStatusWrapper legal = (LegalStatusWrapper)legals.get(i);
%>
      <tr class="<%=cssClass%>">
        <td>
          <a href="references/<%=legal.getIdDc()%>"><%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getDetailedReference()))%></a>
        </td>
        <td>
          <%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getLegalText()))%>
        </td>
        <td>
          <%=Utilities.treatURLSpecialCharacters(legal.getComments())%>
        </td>
        <td>
<%
      if(null != legal.getUrl().replaceAll("#",""))
      {
        String sFormattedURL = Utilities.formatString(legal.getUrl()).replaceAll("#","");
        if(sFormattedURL.length()>50)
        {
          sFormattedURL = sFormattedURL.substring(0,50) + "...";
        }
%>
          <a href="<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getUrl())).replaceAll("#","")%>" title="<%=Utilities.formatString(Utilities.treatURLSpecialCharacters(legal.getUrl())).replaceAll("#","")%>"><%=sFormattedURL%></a>
<%
      }
%>
          &nbsp;
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
<%=cm.cmsMsg("species_factsheet_legalInstruments_01_Sum")%>

<br />
<br />
