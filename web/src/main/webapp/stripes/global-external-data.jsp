<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="Global queries">

    <stripes:layout-component name="contents">

        <!-- MAIN CONTENT -->

            <h2>Global queries of external data</h2>
            
            <c:choose>
                <c:when test="${!actionBean.querySelected}">
                    <p>
                        ${eunis:cmsText(actionBean.contentManagement, 'globalqueries')}
                    </p>
                    <h3>Select a query:</h3>
                    <c:if test="${not empty actionBean.queries}">
                        <dl>
                            <c:forEach items="${actionBean.queries}" var="query" varStatus="loop">
                                <dt>
                                    <stripes:link beanclass="${actionBean.class.name}" rel="nofollow">
                                        <c:out value="${query.title}"/>
                                        <stripes:param name="query" value="${query.id}"/>
                                    </stripes:link>
                                </dt>
                                <dd>
                                    ${query.summary}
                                </dd>
                            </c:forEach>
                        </dl>
                    </c:if>
                    <c:if test="${empty actionBean.queries}">
                        <p>No selectable queries were found! Please use the "Contact us" link if you think this is incorrect.</p>
                    </c:if>
                </c:when>
                <c:otherwise>
                
                    <div style="font-weight:bold">Select a query:</div>
                    <c:if test="${not empty actionBean.queries}">
                        <stripes:form beanclass="${actionBean.class.name}" method="get">
	                        <p>
	                            <stripes:select name="query">
	                                <stripes:options-collection collection="${actionBean.queries}" label="title" value="id"/>
	                            </stripes:select>
	                            <stripes:submit name="defaultEvent" value="Execute query"/>
	                        </p>
                        </stripes:form>
                    </c:if>
                    <c:if test="${empty actionBean.queries}">
                        <p>No selectable queries were found! Please use the "Contact us" link if you think this is incorrect.</p>
                    </c:if>
                    <c:choose>
                        <c:when test="${not empty actionBean.queryResultCols && not empty actionBean.queryResultRows}">
							<div style="overflow-x:auto ">
							    <display:table name="actionBean.queryResultRows" class="sortable" pagesize="100" sort="list" requestURI="${actionBean.urlBinding}">
							    <display:setProperty name="paging.banner.placement" value="both" />
							        <c:forEach var="cl" items="${actionBean.queryResultCols}">
							            <display:column property="${cl.property}" title="${cl.title}" sortable="${cl.sortable}" decorator="eionet.eunis.util.decorators.ForeignDataColumnDecorator"/>
							              </c:forEach>
							          </display:table>
							      </div>
							<c:if test="${not empty actionBean.attribution}">
							    <b>Source:</b> ${actionBean.attribution}
							</c:if>
		                </c:when>
		                <c:otherwise>
		                    <div style="font-weight:bold">Query didn't return any result!</div>
		                </c:otherwise>
		            </c:choose>
                </c:otherwise>
            </c:choose>

        <!-- END MAIN CONTENT -->

    </stripes:layout-component>
    <stripes:layout-component name="foot">
        <!-- start of the left (by default at least) column -->
            <div id="portal-column-one">
                <div class="visualPadding">
                    <jsp:include page="/inc_column_left.jsp">
                        <jsp:param name="page_name" value="countries" />
                    </jsp:include>
                </div>
            </div>
            <!-- end of the left (by default at least) column -->
    </stripes:layout-component>
</stripes:layout-render>
