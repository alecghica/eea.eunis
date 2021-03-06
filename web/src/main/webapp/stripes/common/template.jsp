<%@ include file="/stripes/common/taglibs.jsp"%>	

<stripes:layout-definition>
	<%--
	  - Author(s) : The EUNIS Database Team.
	  - Date :
	  - Copyright : (c) 2002-2010 EEA - European Environment Agency.
	  - Description : Template
	--%>
	<%@page contentType="text/html;charset=UTF-8"%>
	
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html lang="${actionBean.context.sessionManager.currentLanguage}" xmlns="http://www.w3.org/1999/xhtml" xml:lang="${actionBean.context.sessionManager.currentLanguage}">
		<head>
			<base href="${actionBean.context.domainName}/${base}"/>
			<jsp:include page="/header-page.jsp">
				<jsp:param name="metaDescription" value="${eunis:replaceTags(actionBean.metaDescription)}" />
			</jsp:include>
			
			<title>
				<c:choose>
		        	<c:when test="${empty pageTitle}">
		        		EUNIS
					</c:when>
					<c:otherwise>
						${eunis:replaceTags(pageTitle)}
					</c:otherwise>
				</c:choose>
			</title>
			<link rel="stylesheet" type="text/css" href="http://serverapi.arcgisonline.com/jsapi/arcgis/2.7/js/dojo/dijit/themes/claro/claro.css"/>
    		<script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=2.7"></script>
    		<stripes:layout-component name="head"/>
		</head>
		<body>
    		<div id="overDiv" style="z-index: 1000; visibility: hidden; position: absolute"></div>
    		<div id="visual-portal-wrapper">
      			<jsp:include page="/header.jsp" />
      			<!-- The wrapper div. It contains the three columns. -->
      			<c:choose>
		        	<c:when test="${empty layout}">
		        		<div id="portal-columns" class="visualColumnHideTwo">
					</c:when>
					<c:otherwise>
						<div id="portal-columns" class="${layout}">
					</c:otherwise>
				</c:choose>
        			<!-- start of the main and left columns -->
        			<div id="visual-column-wrapper">
          				<!-- start of main content block -->
          				<div id="portal-column-content">
            				<div id="content">
              					<div class="documentContent" id="region-content">
                					<jsp:include page="/header-dynamic.jsp">
                  						<jsp:param name="location" value="${actionBean.btrail}"/>
                					</jsp:include>
                					<a name="documentContent"></a>
									<!-- MAIN CONTENT -->
									<stripes:layout-component name="messages">
									<c:choose>
										<c:when test="${actionBean.context.severity == 1}">
											<div class="system-msg">
												<stripes:messages/>
											</div>
										</c:when>
										<c:when test="${actionBean.context.severity == 2}">
											<div class="caution-msg">
												<strong>Caution ...</strong>		
												<p><stripes:messages/></p>
											</div>
										</c:when>
										<c:when test="${actionBean.context.severity == 3}">
											<div class="warning-msg">
												<strong>Warnings ...</strong>		
												<p><stripes:messages/></p>
											</div>
										</c:when>
										<c:when test="${actionBean.context.severity == 4}">
											<div class="error-msg">
												<strong>Errors ...</strong>		
												<p><stripes:messages/></p>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
								</stripes:layout-component>
								
								<stripes:layout-component name="contents"/>
									<!-- END MAIN CONTENT -->
              					</div>
            				</div>
          				</div>
          				<!-- end of main content block -->
        			<stripes:layout-component name="foot"/>
      		<!-- end column wrapper -->
      		</div>

  			<!-- end of the main and left columns -->
			<div class="visualClear"><!-- --></div>
      		<jsp:include page="/footer-static.jsp" />
  			</div>
    	</div>
  </body>
</html>
</stripes:layout-definition>
