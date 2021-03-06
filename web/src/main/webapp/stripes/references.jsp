<%@page contentType="text/html;charset=UTF-8"%>

<%@ include file="/stripes/common/taglibs.jsp"%>

<stripes:layout-render name="/stripes/common/template.jsp" pageTitle="References">

    <stripes:layout-component name="contents">
        <!-- MAIN CONTENT value="${actionBean.defaultFilterValue}"-->

        <h2>References:</h2>
        <stripes:form action="/references" method="get" name="f">
            <stripes:text size="38"
                name="filterPhrase"
                onfocus="if(this.value=='${actionBean.defaultFilterValue}')this.value='';"
                onblur="if(this.value=='')this.value='${actionBean.defaultFilterValue}';"
                title="${actionBean.defaultFilterValue}"
                />
             <stripes:submit   value="Filter" name="filterPrase2" />
         </stripes:form>
         <br/>
         <display:table name="${actionBean.refs}" class="sortable" sort="external" id="listItem" htmlId="listItem" requestURI="/references" decorator="eionet.eunis.util.decorators.ReferencesTableDecorator">
             <display:column property="idRef" title="ID" sortable="true"/>
             <display:column property="refTitle" title="Title" sortable="true"/>
             <display:column property="author" title="Author" sortable="true" decorator="eionet.eunis.util.decorators.ReplaceTagsColumnDecorator"/>
             <display:column property="refYear" title="Year" sortable="true"/>
         </display:table>

        <!-- END MAIN CONTENT -->
    </stripes:layout-component>
    <stripes:layout-component name="foot">
        <!-- start of the left (by default at least) column -->
            <div id="portal-column-one">
                <div class="visualPadding">
                      <jsp:include page="/inc_column_left.jsp">
                        <jsp:param name="page_name" value="references" />
                      </jsp:include>
                </div>
              </div>
              <!-- end of the left (by default at least) column -->
    </stripes:layout-component>
</stripes:layout-render>
