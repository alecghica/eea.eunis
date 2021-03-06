<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>
<c:set var="title" value=""></c:set>
<c:choose>
	<c:when test="${eunis:exists(actionBean.factsheet)}">
		<c:set var="title" value="${actionBean.scientificName }"></c:set>
	</c:when>
	<c:otherwise>
		<c:set var="title" value="${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}"></c:set>
	</c:otherwise>
</c:choose>
<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="${title}">
	<stripes:layout-component name="head">
		<script src="<%=request.getContextPath()%>/script/species.js" type="text/javascript"></script>
		<script src="<%=request.getContextPath()%>/script/overlib.js" type="text/javascript"></script>
		<link rel="alternate"
			type="application/rdf+xml" title="RDF"
			href="${pageContext.request.contextPath}/species/${actionBean.idSpecies}/rdf" />
	</stripes:layout-component>

	<stripes:layout-component name="contents">
		<!-- MAIN CONTENT -->

		<c:choose>
			<c:when test="${eunis:exists(actionBean.factsheet)}">

			<img alt="${eunis:cms(actionBean.contentManagement,'loading_data')}" id="loading" src="images/loading.gif" />
			  <h1 class="documentFirstHeading">${eunis:replaceTags(actionBean.scientificName)}
			  <c:if test="${actionBean.seniorSpecies != null}">
			    <span class="redirection-msg">&#8213; Synonym of <a href="${pageContext.request.contextPath}/species/${actionBean.seniorIdSpecies}"><strong>${actionBean.seniorSpecies }</strong></a></span>
			  </c:if></h1>
			<div class="documentActions">
			  <h5 class="hiddenStructure">${eunis:cmsPhrase(actionBean.contentManagement, 'Document Actions') }</h5>
			  <ul>
			    <li>
			      <a href="javascript:this.print();"><img src="http://webservices.eea.europa.eu/templates/print_icon.gif"
			            alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}"
			            title="${eunis:cmsPhrase(actionBean.contentManagement, 'Print this page')}" /></a>
			    </li>
			    <li>
			      <a href="javascript:toggleFullScreenMode();"><img src="http://webservices.eea.europa.eu/templates/fullscreenexpand_icon.gif"
			             alt="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}"
			             title="${eunis:cmsPhrase(actionBean.contentManagement, 'Toggle full screen mode')}" /></a>
			    </li>
			    <li>
			      <a href="javascript:openLink('species-factsheet-pdf.jsp?idSpecies=${actionBean.factsheet.idSpecies}&amp;idSpeciesLink=${actionBean.factsheet.idSpeciesLink}');">
			      	<img src="images/pdf.png"
			             alt="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}"
			             title="${eunis:cms(actionBean.contentManagement, 'header_download_pdf_title')}" /></a>
			             ${eunis:cmsTitle(actionBean.contentManagement, 'header_download_pdf_title')}
			    </li>
			  </ul>
			  </div>
			  <br clear="all" />
		                <div id="tabbedmenu">
		                  <ul>
			              	<c:forEach items="${actionBean.tabsWithData }" var="dataTab">
		              		<c:choose>
		              			<c:when test="${dataTab.id eq actionBean.tab}">
			              			<li id="currenttab">
			              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
			              				href="species/${actionBean.factsheet.idSpecies}/${dataTab.id}">${dataTab.value}</a>
			              			</li>
		              			</c:when>
		              			<c:otherwise>
		              				<li>
			              				<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'show')} ${dataTab.value}"
			              				 href="species/${actionBean.factsheet.idSpecies}/${dataTab.id}">${dataTab.value}</a>
			              			</li>
		              			</c:otherwise>
		              		</c:choose>
		              		</c:forEach>
		                  </ul>
		                </div>
		                <br style="clear:both;" clear="all" />
		                <br />
		                <c:if test="${actionBean.tab == 'general'}">
		                	<%-- General information--%>
			                <stripes:layout-render name="/stripes/species-factsheet-general.jsp"/>
		                </c:if>
		                <c:if test="${actionBean.tab == 'vernacular'}">
		                	<%-- Vernacular names tab --%>
		                	<stripes:layout-render name="/stripes/species-factsheet-vern.jsp"/>
		                </c:if>
		                <c:if test="${actionBean.tab == 'geo'}">
		                	<%-- Geographical distribution --%>
		                	<stripes:layout-render name="/stripes/species-factsheet-geo.jsp"/>
		                </c:if>
		                <c:if test="${actionBean.tab == 'population'}">
		                	<%-- Population --%>
			                <jsp:include page="/species-factsheet-pop.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 'trends'}">
		                	<%-- Trends --%>
			                <jsp:include page="/species-factsheet-trends.jsp">
			                  <jsp:param name="name" value="${actionBean.scientificName}" />
			                  <jsp:param name="idNatureObject" value="${actionBean.factsheet.speciesNatureObject.idNatureObject}" />
			                  <jsp:param name="idSpecies" value="${actionBean.factsheet.speciesNatureObject.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 'grid'}">
		                	<%-- Grid distribution --%>
			                <stripes:layout-render name="/stripes/species-factsheet-distribution.jsp"/>
		                </c:if>
		                <c:if test="${actionBean.tab == 'legal'}">
		                	<%-- Legal instruments --%>
			                <jsp:include page="/species-factsheet-legal.jsp">
			                  <jsp:param name="mainIdSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 'habitats'}">
		                	<%-- Related habitats --%>
			                <jsp:include page="/species-factsheet-habitats.jsp">
			                  <jsp:param name="mainIdSpecies" value="${actionBean.factsheet.idSpecies}" />
			                </jsp:include>
		                </c:if>
		                <c:if test="${actionBean.tab == 'sites'}">
		                	<%-- Related sites --%>
		                	<stripes:layout-render name="/stripes/species-factsheet-sites.jsp"/>
		                </c:if>
		                <c:if test="${actionBean.tab == 'conservation_status'}">
		                	<%-- Foreigndata --%>
							<stripes:layout-render name="/stripes/species-factsheet-conservation-status.jsp"/>

		                </c:if>
		                <c:if test="${actionBean.tab == 'linkeddata'}">
		                	<%-- Foreigndata --%>
		                	<stripes:layout-render name="/stripes/species-factsheet-linkeddata.jsp"/>
		                </c:if>
			</c:when>
			<c:otherwise>
				<div class="error-msg">
		           ${eunis:cmsPhrase(actionBean.contentManagement, 'We are sorry, the requested species does not exist')}
		        </div>

			</c:otherwise>
		</c:choose>
			<c:forEach items="${actionBean.tabs}" var="tab">
				${eunis:cmsMsg(actionBean.contentManagement, tab)}
				${eunis:br(actionBean.contentManagement)}
			</c:forEach>
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'species_factsheet_title')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'show')}
		    ${eunis:br(actionBean.contentManagement)}
		    ${eunis:cmsMsg(actionBean.contentManagement, 'loading_data')}
		    ${eunis:br(actionBean.contentManagement)}
		<!-- END MAIN CONTENT -->
		<script type="text/javascript">
	    //<![CDATA[
	      try
	      {
	        var ctrl_loading = document.getElementById( "loading" );
	        ctrl_loading.style.display = "none";
	      }
	      catch ( e )
	      {
	      }
	        // Writes a warning if the page is called as a popup. Works only in IE
	        if ( history.length == 0 && document.referrer != '') {
	            c = document.getElementById('content');
	            w = document.createElement('div');
	            w.className = "note-msg";
	            w.innerHTML = "<strong>Notice</strong> <p>This page was opened as a new window. The back button has been disabled by the referring page. Close the window to exit.</p>";
	            c.insertBefore(w, c.firstChild);
	        }
	      //]]>
	    </script>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="species-factsheet.jsp" />
              		</jsp:include>
<dl class="portlet portlet-navigation-tree">
  <dd class="portletItem">
    <ul class="portletNavigationTree navTreeLevel0">
        <c:if test="${actionBean.factsheet.hasPictures}">
      <li class="navTreeItem visualNoMarker">
                <a href="javascript:openpictures('${actionBean.domainName}/pictures.jsp?idobject=${actionBean.idSpecies}&amp;natureobjecttype=Species',600,600)">${eunis:cmsPhrase(actionBean.contentManagement, 'View pictures')}</a>
      </li>
        </c:if>
        <c:if test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.upload_pictures_RIGHT}">
      <li class="navTreeItem visualNoMarker">
                <a href="javascript:openpictures('${actionBean.domainName}/pictures-upload.jsp?operation=upload&amp;idobject=${actionBean.idSpecies}&amp;natureobjecttype=Species',600,600)">${eunis:cmsPhrase(actionBean.contentManagement, 'Upload pictures')}</a>
      </li>
        </c:if>
    </ul>
    <span class="portletBottomLeft"></span>
    <span class="portletBottomRight"></span>
  </dd>
</dl>

            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
	</stripes:layout-component>
</stripes:layout-render>
