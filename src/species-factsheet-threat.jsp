<%--
  - Author(s) : The EUNIS Database Team.
  - Date :
  - Copyright : (c) 2002-2005 EEA - European Environment Agency.
  - Description : 'Species factsheet' - Display national threat status.
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@page import="java.util.*,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.species.SpeciesSearchUtility,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.search.UniqueVector,
                 ro.finsiel.eunis.factsheet.species.ThreatColor,
                 java.net.URL,
                 java.net.HttpURLConnection,
                 java.io.*,
                 ro.finsiel.eunis.factsheet.species.SpeciesFactsheet,
                 ro.finsiel.eunis.factsheet.species.NationalThreatWrapper,
                ro.finsiel.eunis.WebContentManagement"%>
  <jsp:useBean id="FormBean" class="ro.finsiel.eunis.formBeans.SpeciesFactSheetBean" scope="page">
    <jsp:setProperty name="FormBean" property="*"/>
  </jsp:useBean>
  <jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
    WebContentManagement cm = SessionManager.getWebContent();

    Integer idSpecies=Utilities.checkedStringToInt( request.getParameter("idSpecies"), new Integer("-1") );
    SpeciesFactsheet factsheet = new SpeciesFactsheet( idSpecies, idSpecies );
    String scientificName = factsheet.getSpeciesObject().getScientificName();

    // National threat status
    List nationalThreatStatus = factsheet.getNationalThreatStatus( factsheet.getSpeciesObject() );

    // List of species international threat status.
    List consStatus = factsheet.getConservationStatus(factsheet.getSpeciesObject());

    for ( int i = 0; i < nationalThreatStatus.size(); i++ )
    {
      NationalThreatWrapper threat = ( NationalThreatWrapper )nationalThreatStatus.get(i);
      Chm62edtCountryPersist country = new Chm62edtCountryPersist();
      country.setAreaNameEnglish(threat.getCountry());
      country.setIso2l(threat.getIso2L());
    }
    if( nationalThreatStatus.size() > 0 )
    {
%>
    <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet-threat_10")%></div>
<%
    int COUNTRIES_PER_MAP = Utilities.checkedStringToInt( application.getInitParameter( "COUNTRIES_PER_MAP" ), 120 );
    // Mapping THREAT STATUS - COLOR
    Hashtable threatsColors;
    List threats = SpeciesSearchUtility.processThreats(nationalThreatStatus);
    // Fill the THREAT STATUS - COLOR mappings
    UniqueVector v = new UniqueVector();
    for (int i  = 0; i < threats.size(); i++)
    {
      NationalThreatWrapper tw = (NationalThreatWrapper)threats.get(i);
      v.addElement(tw.getStatus());
    }
    threatsColors = ThreatColor.getColorsForMap(v);

    //fix to display in map legend only visible colours
    v.clear();

    String mapURL = "";
    // Prepare the URL string for the map server (pairs of 'country_code:color')
    Vector addedThreats = new Vector();

    for (int i = 0; i < threats.size(); i++)
    {
      NationalThreatWrapper tw = (NationalThreatWrapper)threats.get(i);
      String code = tw.getIso2L();
      if ( !addedThreats.contains( tw.getCountry() ) )
      {
        if (null != code && !code.equalsIgnoreCase(""))
        {
          addedThreats.add( tw.getCountry() );
          String color = (String)threatsColors.get(tw.getStatus().toLowerCase());
          mapURL += code + ":H" + color;
          if (i < (threats.size() - 1)) mapURL += ",";
        }
        //fix to display in map legend only visible colours
        v.addElement( tw.getStatus() );
      }
    }

    //fix to display in map legend only visible colours
    threatsColors = ThreatColor.getColorsForMap(v);

    if ( addedThreats.size() < COUNTRIES_PER_MAP )
    {
      // Do the map request
      String extension=application.getInitParameter("EEA_MAP_SERVER_EXTENSION"); //default image type for maps
      String url = application.getInitParameter("EEA_MAP_SERVER") + "/getmap.asp";
      String parameters = "mapType=Standard_B&amp;Q=" + mapURL + "&amp;outline=1";
      String proxy = application.getInitParameter("PROXY_URL");
      int port = ro.finsiel.eunis.search.Utilities.checkedStringToInt(application.getInitParameter("PROXY_PORT"),0);
      String filename = url + "?" + parameters;
%>
      <table summary="layout" border="0" cellpadding="3" cellspacing="0" width="100%">
        <tr>
          <td>
<%
          if(filename.length() > 0)
          {
%>
            <img alt="<%=cm.cms("map_image_eea")%>" src="<%=filename%>" title="<%=cm.cms("map_image_eea")%>" />
            <%=cm.cmsAlt("map_image_eea")%>
            <br />
            <a title="<%=cm.cms("species_factsheet-threat_11_Title")%>" href="javascript:openNewPage('<%=url + "?" + parameters%>');"><%=cm.cmsText("species_factsheet-threat_11")%></a>
            <%=cm.cmsTitle("species_factsheet-threat_11_Title")%>
<%
          }
          else
          {
%>
            <%=cm.cmsText("species_factsheet-threat_02")%>.
<%
          }
%>
          </td>
          <td style="padding-left : 20px;">
            <%=cm.cmsText("legend")%>:
            <br />
<%
          Enumeration keys = threatsColors.keys();
          while ( keys.hasMoreElements() )
          {
            String key = ( String )keys.nextElement();
%>
            <img alt="<%=cm.cms("map_legend_eea")%>" src="<%=application.getInitParameter("EEA_MAP_SERVER")%>/getLegend.asp?Color=H<%=threatsColors.get(key)%>" title="<%=cm.cms("map_legend_eea")%>" /><%=cm.cmsAlt("map_legend_eea")%>&nbsp;<%=key%>
            <br />
<%
          }
%>
            <p>
              <%=cm.cmsText("species_factsheet-threat_03")%>
            </p>
          </td>
        </tr>
      </table>
<%
    }
%>
      <table summary="<%=cm.cms("species_factsheet-threat_12_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="threat" class="sortable">
        <tr>
          <th style="width : 220px;" title="<%=cm.cms("sort_results_on_this_column")%>">
            <strong>
              <%=cm.cmsText("species_factsheet-threat_04")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th style="width : 120px;" title="<%=cm.cms("sort_results_on_this_column")%>">
            <strong>
              <%=cm.cmsText("species_factsheet-threat_05")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th style="width : 100px;" title="<%=cm.cms("sort_results_on_this_column")%>">
            <strong>
              <%=cm.cmsText("species_factsheet-threat_06")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>" title="<%=cm.cms("sort_results_on_this_column")%>">
            <strong>
              <%=cm.cmsText("species_factsheet-threat_07")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
        </tr>
<%
  for (int i = 0; i < nationalThreatStatus.size(); i++)
  {
    NationalThreatWrapper threat = (NationalThreatWrapper)nationalThreatStatus.get(i);
%>
        <tr style="background-color:<%=((0 == i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%
                if(Utilities.isCountry(threat.getCountry()))
                {
            %>
              <a href="javascript:goToCountryStatistics('<%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>')" title="<%=cm.cms("open_statistical_data")%> <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>"><%=Utilities.treatURLSpecialCharacters(threat.getCountry())%></a>
              <%=cm.cmsTitle("open_statistical_data")%>
            <%
            } else {
            %>
             <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>
            <%
             }
            %>
              &nbsp;
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(threat.getStatus())%>
          </td>
          <td>
          <span class="boldUnderline" title="<%=factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ")%>">
            <%=threat.getThreatCode()%>
          </span>
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(threat.getReference())%>
          </td>
        </tr>
        <%
          }
        %>
      </table>
<%
    }

    // International threat status
    if( consStatus.size() > 0 )
    {
%>
      <br />
      <div style="width : 100%; background-color : #CCCCCC; font-weight : bold;"><%=cm.cmsText("species_factsheet-threat_13")%></div>
      <table summary="<%=cm.cms("species_factsheet-threat_13_Sum")%>" width="100%" border="1" cellspacing="1" cellpadding="0" id="intlthreat" class="sortable">
        <tr>
          <th title="<%=cm.cms("sort_results_on_this_column")%>">
            <strong>
              <%=cm.cmsText("species_factsheet-conservation_08")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>" >
            <strong>
              <%=cm.cmsText("species_factsheet-conservation_03")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>" >
            <strong>
              <%=cm.cmsText("species_factsheet-conservation_09")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
          <th title="<%=cm.cms("sort_results_on_this_column")%>" >
            <strong>
              <%=cm.cmsText("species_factsheet-conservation_05")%>
              <%=cm.cmsTitle("sort_results_on_this_column")%>
            </strong>
          </th>
        </tr>
<%
       // Display results.
      for (int i = 0; i < consStatus.size(); i++)
      {
        NationalThreatWrapper threat = (NationalThreatWrapper)consStatus.get(i);
%>
        <tr style="background-color:<%=((0 == i % 2) ? "#EEEEEE" : "#FFFFFF")%>">
          <td>
            <%=Utilities.treatURLSpecialCharacters(threat.getCountry())%>
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(threat.getStatus())%>
          </td>
          <td>
          <span class="boldUnderline" title="<%=factsheet.getConservationStatusDescriptionByCode(threat.getThreatCode()).replaceAll("'"," ").replaceAll("\""," ")%>">
            <%=threat.getThreatCode()%>
          </span>
          </td>
          <td>
            <%=Utilities.treatURLSpecialCharacters(threat.getReference())%>
          </td>
        </tr>
<%
          }
%>
      </table>
<%
    }
%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-threat_12_Sum")%>
<%=cm.br()%>
<%=cm.cmsMsg("species_factsheet-threat_13_Sum")%>

<br />
<br />