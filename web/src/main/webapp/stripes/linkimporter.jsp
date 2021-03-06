<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Import Links">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Import Links</h1>
	        <stripes:form action="/dataimport/importpagelinks" method="post" name="f">
	        	<stripes:file name="file"/><br/>
	        	<stripes:checkbox name="hasGBIF" id="gbif"/>
	        	<stripes:label for="gbif"> - GBIF</stripes:label>
	        	<stripes:checkbox name="hasBiolab" id="biolab"/>
	        	<stripes:label for="biolab"> - BioLib</stripes:label>
	        	<stripes:checkbox name="hasBbc" id="bbc"/>
	        	<stripes:label for="bbc"> - BBC</stripes:label>
	        	<stripes:checkbox name="hasWikipedia" id="wiki"/>
	        	<stripes:label for="wiki"> - Wikipedia</stripes:label>
	        	<stripes:checkbox name="hasWikispecies" id="wikis"/>
	        	<stripes:label for="wikis"> - Wikispecies</stripes:label>
	        	<stripes:checkbox name="hasBugGuide" id="bug"/>
	        	<stripes:label for="bug"> - BugGuide</stripes:label>
	        	<stripes:checkbox name="hasNCBI" id="ncbi"/>
	        	<stripes:label for="ncbi"> - NCBI</stripes:label>
	        	<stripes:checkbox name="hasITIS" id="itis"/>
	        	<stripes:label for="itis"> - ITIS</stripes:label><br/>
	        	<strong>Matching: </strong>
	        	<stripes:radio name="matching" id="matching_species" value="sameSpecies"/><stripes:label for="matching_species"> - sameSpecies</stripes:label>
	        	<stripes:radio name="matching" id="matching_synonym" value="sameSynonym"/><stripes:label for="matching_synonym"> - sameSynonym</stripes:label><br/>
	        	<stripes:checkbox name="delete" id="delete"/>
	        	<stripes:label for="delete"> - delete old records</stripes:label><br/>
				<stripes:submit name="importLinks" value="Import"/>
			</stripes:form>
		</c:when>
		<c:otherwise>
			<div class="error-msg">
				You are not logged in or you do not have enough privileges to view this page!
			</div>
		</c:otherwise>
	</c:choose>
	</stripes:layout-component>
	<stripes:layout-component name="foot">
		<!-- start of the left (by default at least) column -->
			<div id="portal-column-one">
            	<div class="visualPadding">
              		<jsp:include page="/inc_column_left.jsp">
                		<jsp:param name="page_name" value="dataimport/importpagelinks" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
	</stripes:layout-component>
</stripes:layout-render>
