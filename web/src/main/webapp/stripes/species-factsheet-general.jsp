<%@page contentType="text/html;charset=UTF-8"%>
<%@ include file="/stripes/common/taglibs.jsp"%>
<stripes:layout-definition>
	<c:if test="${!empty actionBean.pic && !empty actionBean.pic.filename}">
		<div class="naturepic-plus-container naturepic-right">
	  		<div class="naturepic-plus">
	    		<div class="naturepic-image">
			   		<a href="javascript:openpictures('${actionBean.pic.domain}/pictures.jsp?idobject=${actionBean.idSpecies}&amp;natureobjecttype=Species',600,600)">
				    	<img src="${actionBean.pic.path}/${actionBean.pic.filename}" alt="${actionBean.pic.description}" class="scaled" style="${actionBean.pic.style}"/>
				    </a>
			    </div>
			    <div class="naturepic-note">
              		${actionBean.pic.description}
	    		</div>
	    		<c:if test="${!empty actionBean.pic.source}">
					<div class="naturepic-source-copyright">
						${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}:
						<c:choose>
							<c:when test="${!empty actionBean.pic.sourceUrl}">
								<a href="${eunis:treatURLSpecialCharacters(actionBean.pic.sourceUrl)}">${actionBean.pic.source}</a>
							</c:when>
							<c:otherwise>
								${actionBean.pic.source}
							</c:otherwise>
						</c:choose>
						<c:if test="${!empty actionBean.pic.license}">
							&nbsp;(${actionBean.pic.license})
						</c:if>
					</div>
	    		</c:if>
	  		</div>
  		</div>
	</c:if>
	<div class="allow-naturepic">
		<table class="datatable fullwidth">
			<col style="width:20%"/>
			<col style="width:40%"/>
			<col style="width:20%"/>
			<col style="width:20%"/>
			<tr>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}</th><td>${actionBean.scientificName }</td>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Taxonomic rank')}</th><td>${actionBean.factsheet.speciesObject.typeRelatedSpecies}</td>
	      		</tr>
			<tr>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}</th><td>${actionBean.author}</td>
				<th scope="row">${eunis:cmsPhrase(actionBean.contentManagement, 'Valid name')}</th><td>${eunis:getYesNo(actionBean.factsheet.speciesObject.validName)}</td>
	      		</tr>
		</table>
		<table class="datatable fullwidth">
			<col style="width:20%"/>
			<col style="width:40%"/>
			<col style="width:40%"/>
	    	<thead>
	      		<tr>
	        		<th colspan="2">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Taxonomic information')}
	        		</th>
	        		<th>
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
	        		</th>
	      		</tr>
	    	</thead>
	    	<tbody>
	    		<c:forEach items="${actionBean.classifications}" var="classif" varStatus="loop">
					<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
						<td>
	          				${classif.level}
	        			</td>
	        			<td style="font-weight:bold">
		            			${classif.name}
	        			</td>
	        			<c:if test="${classif.level == 'Kingdom'}">
	        				<td rowspan="${fn:length(actionBean.classifications) + 1}" style="text-align:center; background-color:#EEEEEE; vertical-align:middle;font-weight:bold">
	            					${eunis:treatURLSpecialCharacters(actionBean.authorDate)}
	        				</td>
	        			</c:if>
					</tr>
				</c:forEach>
				<tr class="zebraeven">
	        		<td>
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Genus')}
	        		</td>
	        		<td style="font-weight:bold">
	            			${actionBean.specie.genus}
	        		</td>
	      		</tr>
	    	</tbody>
	    </table>
	    <h2>${eunis:cmsPhrase(actionBean.contentManagement, 'External links')}</h2>
	  	<div id="linkcollection">
		    <div>
		        <a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Pictures of the species on Google')}" href="http://images.google.com/images?q=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Pictures on Google')}</a>
			</div>
			<c:choose>
				<c:when test="${!empty actionBean.gbifLink}">
					<div>
		        		<a href="http://data.gbif.org/species/${actionBean.gbifLink}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF page')}</a>
		      		</div>
				</c:when>
		  		<c:otherwise>
					<div>
		        		<a href="http://data.gbif.org/species/${actionBean.gbifLink2}">${eunis:cmsPhrase(actionBean.contentManagement, 'GBIF search')}</a>
		      		</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${actionBean.natureObjectAttributesMap['sameSynonymAnimalsWCMC'] == null && actionBean.natureObjectAttributesMap['sameSynonymPlantsWCMC'] == null}">
				<div>
		        	<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on UNEP-WCMC')}" href="http://www.unep-wcmc-apps.org/isdb/Taxonomy/tax-gs-search2.cfm?displaylanguage=ENG&amp;source=${actionBean.kingdomname}&amp;GenName=${actionBean.specie.genus}&amp;SpcName=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'UNEP-WCMC search')}</a>
		      	</div>
			</c:if>
			<c:choose>
				<c:when test="${!empty actionBean.redlistLink}">
					<div>
		        		<a href="http://www.iucnredlist.org/apps/redlist/details/${actionBean.redlistLink}/0">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List page')}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<div>
			  			<a href="http://www.iucnredlist.org/apps/redlist/search/external?text=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;mode=">${eunis:cmsPhrase(actionBean.contentManagement, 'IUCN Red List search')}</a>
			  		</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${actionBean.factsheet.speciesGroup == 'fishes'}">
				<div>
					<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fishbase')}" href="http://www.fishbase.de/Summary/SpeciesSummary.php?genusname=${actionBean.specie.genus}&amp;speciesname=${eunis:treatURLSpecialCharacters(actionBean.speciesName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fishbase search')}</a>
				</div>
			</c:if>
			<c:if test="${!empty actionBean.wormsid}">
				<div>
					<a href="http://www.marinespecies.org/aphia.php?p=taxdetails&amp;id=${actionBean.wormsid}" title="World Register of Marine Species page">${eunis:cmsPhrase(actionBean.contentManagement, 'WoRMS page')}</a>
				</div>
			</c:if>
			<c:choose>
				<c:when test="${!empty actionBean.faeu}">
					<div>
			        	<a href="http://www.faunaeur.org/full_results.php?id=${actionBean.faeu}">${eunis:cmsPhrase(actionBean.contentManagement, 'Fauna Europaea page')}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<c:if test="${actionBean.kingdomname == 'Animals'}">
					<div>
						<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on Fauna Europaea')}" href="http://www.faunaeur.org/index.php?show_what=search%20results&amp;genus=${actionBean.specie.genus}&amp;species=${actionBean.speciesName}">${eunis:cmsPhrase(actionBean.contentManagement, 'Search Fauna Europaea')}</a>
					</div>
					</c:if>
				</c:otherwise>
			</c:choose>
			<c:if test="${empty actionBean.itisTSN}">
				<div>
				<a href="http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=Scientific_Name&amp;search_kingdom=every&amp;search_span=exactly_for&amp;search_value=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}&amp;categories=All&amp;source=html&amp;search_credRating=All">${eunis:cmsPhrase(actionBean.contentManagement, 'Search ITIS')}</a>
				</div>
			</c:if>
			<c:choose>
				<c:when test="${!empty actionBean.ncbi}">
					<div>
			        	<a href="http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=${actionBean.ncbi}&amp;lvl=0">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI:')}${actionBean.ncbi}</a>
					</div>
				</c:when>
		  		<c:otherwise>
					<div>
						<a title="${eunis:cmsPhrase(actionBean.contentManagement, 'Search species on NCBI Taxonomy browser')}" href="http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?doptcmdl=ExternalLink&amp;cmd=Search&amp;db=taxonomy&amp;term=${eunis:treatURLSpecialCharacters(actionBean.specie.scientificName)}">${eunis:cmsPhrase(actionBean.contentManagement, 'NCBI Taxonomy search')}</a>
					</div>
				</c:otherwise>
			</c:choose>
			<c:if test="${!empty actionBean.n2000id}">
				<div>
					${eunis:cmsPhrase(actionBean.contentManagement, 'N2000 code:')} ${actionBean.n2000id}
				</div>
			</c:if>
			<c:forEach items="${actionBean.links}" var="link" varStatus="loop">
				<div>
				<c:choose>
					<c:when test="${!empty link.url}">
						<a href="${eunis:treatURLSpecialCharacters(link.url)}">${link.name}</a>
					</c:when>
					<c:otherwise>
						${link.name}
					</c:otherwise>
				</c:choose>
				</div>
			</c:forEach>
		</div> <!-- linkcollection -->
	</div> <!-- allow-naturepic -->
	<c:if test="${!empty actionBean.consStatus}">
		<br/><br/><br/>
	  	<h2 style="clear: both">
		    ${eunis:cmsPhrase(actionBean.contentManagement, 'International Threat Status')}
	  	</h2>
	  	<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'International Threat Status')}" class="listing fullwidth">
		<col style="width: 20%"/>
	    	<col style="width: 20%"/>
	    	<col style="width: 20%"/>
	    	<col style="width: 40%"/>
	    	<thead>
	      		<tr>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Area')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Status')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'International threat code')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	        		<th scope="col">
	        			${eunis:cmsPhrase(actionBean.contentManagement, 'Reference')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
	        		</th>
	      		</tr>
	    	</thead>
	    	<tbody>
	    	<c:forEach items="${actionBean.consStatus}" var="threat" varStatus="loop">
	    		<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    			<td>
	          			${eunis:treatURLSpecialCharacters(threat.country)}
	        		</td>
	        		<td>
	          			${eunis:treatURLSpecialCharacters(threat.status)}
	        		</td>
	        		<td>
	        			<span class="boldUnderline" title="${threat.statusDesc}">
	          				${eunis:treatURLSpecialCharacters(threat.threatCode)}
	        			</span>
	        		</td>
	        		<td>
	          			<a href="references/${threat.idDc}">${eunis:treatURLSpecialCharacters(threat.reference)}</a>
	        		</td>
	      		</tr>
	    	</c:forEach>
	    	</tbody>
		</table>
	</c:if>
	<br />
	<c:if test="${!empty actionBean.factsheet.speciesNatureObject.idDublinCore && actionBean.factsheet.speciesNatureObject.idDublinCore != -1}">
	  	<h2 style="clear: both">
		    ${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
	  	</h2>
	  	<table summary="layout" class="datatable fullwidth">
		    <col style="width:20%"/>
		    <col style="width:80%"/>
		    <tbody>
		    	<tr>
	        		<th scope="row">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Title')}:
	        		</th>
	        		<td>
	            			${eunis:treatURLSpecialCharacters(actionBean.speciesBook.title)}
	        		</td>
	      		</tr>
	      		<tr class="zebraeven">
	        		<th scope="row">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}:
	        		</th>
	        		<td>
	            			${eunis:treatURLSpecialCharacters(actionBean.speciesBook.author)}
	        		</td>
	      		</tr>
	      		<tr>
	        		<th scope="row">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Publisher')}:
	        		</th>
	        		<td>
	            			${eunis:treatURLSpecialCharacters(actionBean.speciesBook.publisher)}
	        		</td>
	      		</tr>
	      		<tr class="zebraeven">
	        		<th scope="row">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Publication date')}:
	        		</th>
	        		<td>
	            			${eunis:treatURLSpecialCharacters(actionBean.speciesBook.date)}
	        		</td>
	      		</tr>
	      		<tr>
	        		<th scope="row">
	          			${eunis:cmsPhrase(actionBean.contentManagement, 'Url')}:
	        		</th>
	        		<td>
	        			<c:choose>
						<c:when test="${!empty actionBean.speciesBook.URL}">
				        	<a href="${eunis:replaceAll(eunis:treatURLSpecialCharacters(actionBean.speciesBook.URL),'#','')}">${eunis:replaceAll(eunis:treatURLSpecialCharacters(actionBean.speciesBook.URL),'#','')}</a>
						</c:when>
				  		<c:otherwise>
				  			&nbsp;
						</c:otherwise>
					</c:choose>
				</td>
	      		</tr>
	    	</tbody>
	  	</table>
  	</c:if>
  	<c:if test="${!empty actionBean.factsheet.synonymsIterator}">
  		<h2 style="clear: both">
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Synonyms')}
  		</h2>
  		<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'List of synonyms')}" class="listing fullwidth">
    		<col style="width:40%"/>
    		<col style="width:60%"/>
    		<thead>
      			<tr>
        			<th scope="col">
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
        			</th>
        			<th scope="col">
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Author')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_by_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
	    		<c:forEach items="${actionBean.factsheet.synonymsIterator}" var="synonym" varStatus="loop">
	    			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    				<td>
	        				<a href="${pageContext.request.contextPath}/species/${synonym.idSpecies}">${eunis:treatURLSpecialCharacters(synonym.scientificName)}</a>
	      				</td>
	      				<td>
	          				${eunis:treatURLSpecialCharacters(synonym.author)}
	      				</td>
	    			</tr>
	    		</c:forEach>
    		</tbody>
  		</table>
  	</c:if>
  	<c:if test="${!empty actionBean.subSpecies}">
  		<h2 style="clear: both">
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Valid subspecies')}
  		</h2>
  		<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'List of subspecies')}" class="listing fullwidth">
    		<col style="width:40%"/>
    		<col style="width:60%"/>
    		<thead>
      			<tr>
        			<th>
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th>
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
	    		<c:forEach items="${actionBean.subSpecies}" var="subspecie" varStatus="loop">
	    			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    				<td>
	        				<a style="font-style : italic;" href="species/${subspecie.idSpecies}">${eunis:treatURLSpecialCharacters(subspecie.scientificName)}</a>
          					${eunis:treatURLSpecialCharacters(subspecie.author)}
	      				</td>
	      				<td>
	          				${eunis:treatURLSpecialCharacters(subspecie.bookAuthorDate)}
	      				</td>
	    			</tr>
	    		</c:forEach>
    		</tbody>
  		</table>
  	</c:if>
  	
  	<c:if test="${!empty actionBean.parentSpecies}">
  		<h2 style="clear: both">
    		${eunis:cmsPhrase(actionBean.contentManagement, 'Valid parent species')}
  		</h2>
  		<table summary="${eunis:cmsPhrase(actionBean.contentManagement, 'List of parent species')}" class="listing fullwidth">
    		<col style="width:40%"/>
    		<col style="width:60%"/>
    		<thead>
      			<tr>
        			<th>
          				${eunis:cmsPhrase(actionBean.contentManagement, 'Scientific name')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
        			<th>
        				${eunis:cmsPhrase(actionBean.contentManagement, 'Source')}
	          			${eunis:cmsTitle(actionBean.contentManagement, 'sort_results_on_this_column')}
        			</th>
      			</tr>
    		</thead>
    		<tbody>
	    		<c:forEach items="${actionBean.parentSpecies}" var="parentspecie" varStatus="loop">
	    			<tr ${loop.index % 2 == 0 ? '' : 'class="zebraeven"'}>
	    				<td>
	        				<a style="font-style : italic;" href="species/${parentspecie.idSpecies}">${eunis:treatURLSpecialCharacters(parentspecie.scientificName)}</a>
          					${eunis:treatURLSpecialCharacters(parentspecie.author)}
	      				</td>
	      				<td>
	          				${eunis:treatURLSpecialCharacters(parentspecie.bookAuthorDate)}
	      				</td>
	    			</tr>
	    		</c:forEach>
    		</tbody>
  		</table>
  	</c:if>
  	
  	<br />
</stripes:layout-definition>
