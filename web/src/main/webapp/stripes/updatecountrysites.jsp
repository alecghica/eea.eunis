<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Update country sites factsheet">

	<stripes:layout-component name="contents">

	<c:choose>
		<c:when test="${actionBean.context.sessionManager.authenticated && actionBean.context.sessionManager.importExportData_RIGHT}">
	        <h1>Update country sites factsheet</h1>
	        <stripes:form action="/dataimport/updatecountrysites" method="post" name="f">
				<stripes:submit name="update" value="Update"/>
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
                		<jsp:param name="page_name" value="dataimport/updatecountrysites" />
              		</jsp:include>
            	</div>
          	</div>
          	<!-- end of the left (by default at least) column -->
	</stripes:layout-component>
</stripes:layout-render>
