<%--
  - Author(s)   : The EUNIS Database Team.
  - Date        :
  - Copyright   : (c) 2002-2005 EEA - European Environment Agency.
  - Description : Popup which shows the references for a glossary entry (from 'glossary' results search function).
--%>
<%@page contentType="text/html;charset=UTF-8"%>
<%
  request.setCharacterEncoding( "UTF-8");
%>
<%@ page import="java.util.*,
                 ro.finsiel.eunis.jrfTables.*,
                 ro.finsiel.eunis.search.Utilities,
                 ro.finsiel.eunis.WebContentManagement"%>
<jsp:useBean id="SessionManager" class="ro.finsiel.eunis.session.SessionManager" scope="session" />
<%
  WebContentManagement cm = SessionManager.getWebContent();
  // id - ID_DC from CHM62EDT_GLOSSARY table
  int id = Utilities.checkedStringToInt( request.getParameter("idDc"), -1 );
  // List of glossary references
  List l1 = new DcIndexDomain().findWhere("ID_DC="+id);
  if (l1.size() > 0)
  {
%>
      <table class="listing" width="100%">
        <thead>
          <tr>
            <th>
              <%=cm.cmsPhrase( "Title" )%>
            </th>
            <th>
              <%=cm.cmsPhrase( "Author" )%>
            </th>
            <th>
              <%=cm.cmsPhrase( "Editor" )%>
            </th>
            <th>
              <%=cm.cmsPhrase( "Publisher" )%>
            </th>
            <th>
              <%=cm.cmsPhrase( "Published" )%>
            </th>
          </tr>
        </thead>
        <tbody>
<%
    for (int i = 0; i < l1.size(); i++)
    {
      DcIndexPersist aRef = ((DcIndexPersist) l1.get(i));
      String title=Utilities.formatString(aRef.getTitle());
      String source=Utilities.formatString(aRef.getSource());
      String editor=Utilities.formatString(aRef.getEditor());
      String publisher=Utilities.formatString(aRef.getPublisher());
      // If one of them is not null
      if((editor+title+publisher+source).trim().length()>0)
      {
%>
          <tr>
            <td>
              <%=Utilities.formatString( title, "&nbsp;" )%>
            </td>
            <td>
              <%=Utilities.formatString( source, "&nbsp;" )%>
            </td>
            <td>
              <%=Utilities.formatString( editor, "&nbsp;" )%>
            </td>
            <td>
              <%=Utilities.formatString( publisher, "&nbsp;" )%>
            </td>
<%
        if (null!=aRef.getCreated())
        {
          String dt = Utilities.formatString( aRef.getCreated(), "&nbsp;" );
%>
            <td>
              <%=dt%>
            </td>
<%
        }
        else
        {
%>
            <td>
              &nbsp;
            </td>
<%
        }
%>
          </tr>
        </tbody>
      </table>
<%
      }
      else
      {
%>
      <br />
        <%=cm.cmsPhrase( "No other information available." )%>
      <br />
<%
      }
    }
  }
%>
