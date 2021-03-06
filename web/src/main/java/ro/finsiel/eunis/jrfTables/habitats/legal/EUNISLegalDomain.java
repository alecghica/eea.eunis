package ro.finsiel.eunis.jrfTables.habitats.legal;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;

import java.util.List;
import java.util.Vector;

/**
 * @author finsiel
 * @since 13.02.2003
 * @version 1.0
 * QUERY FOR: *ANY* HABITAT AND *ANY* LEGAL TEXT
 *
 * IMPLEMENTED QUERY:
 * SELECT A.SCIENTIFIC_NAME
 * FROM CHM62EDT_HABITAT AS A
 * INNER JOIN CHM62EDT_HABITAT_REPORT_TYPE AS B ON A.ID_HABITAT = B.ID_HABITAT
 * INNER JOIN CHM62EDT_REPORT_TYPE AS C ON B.ID_REPORT_TYPE = C.ID_REPORT_TYPE
 * INNER JOIN CHM62EDT_HABITAT_DESIGNATED_CODES AS D ON C.ID_LOOKUP = D.ID_HABITAT_CODE
 * WHERE A.EUNIS_HABITAT_CODE LIKE "A%"
 * AND (A.SCIENTIFIC_NAME LIKE "%AC%" OR A.DESCRIPTION LIKE "%AC%")
 * AND C.LOOKUP_TYPE = "HABITAT_CODES"
 * AND D.LEGAL_INSTRUMENT_ABBREV = "Habitats Directive/FFH"
 */
public class EUNISLegalDomain extends AbstractDomain implements Paginable {

  /** Criterias applied for searching */
  private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set
  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted
  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);

  /**
   * Normal constructor
   * @param searchCriteria Criterias used for searching
   */
  public EUNISLegalDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria) {
    this.searchCriteria = searchCriteria;
    this.sortCriteria = sortCriteria;
  }

  /** This constructor is used only for searches specific to JRF (e.g. new EUNISLegalDomain().findWhere(...)) */
  public EUNISLegalDomain() {
  }

  /****/
  public PersistentObject newPersistentObject() {
    return new EUNISLegalPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_HABITAT");

    this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("LEVEL", "getHabLevel", "setHabLevel", DEFAULT_TO_NULL));

    this.setTableAlias("A");
    this.setReadOnly(true);

    JoinTable habitatReportType = null;
    habitatReportType = new JoinTable("CHM62EDT_HABITAT_CLASS_CODE B", "ID_HABITAT", "ID_HABITAT");
    this.addJoinTable(habitatReportType);

    JoinTable reportType = null;
    reportType = new JoinTable("CHM62EDT_CLASS_CODE C", "ID_CLASS_CODE", "ID_CLASS_CODE");
    reportType.addJoinColumn(new StringJoinColumn("NAME", "setLegalName"));
    habitatReportType.addJoinTable(reportType);

  }

  /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
   * index offset.
   * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
   * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
   * @param sortCriteria The criteria used for sorting
   * @return A list of objects which match query criteria
   */
  public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {
    this.sortCriteria = sortCriteria;
    if (searchCriteria.length < 1) throw new CriteriaMissingException("Unable to search because no search criteria was specified...");
    // Prepare the WHERE clause
    StringBuffer filterSQL = _prepareWhereSearch();
    // Add query specific filetering...
    filterSQL.append(" AND C.LEGAL = 1 ");
    // Add GROUP BY clause for unique results
    filterSQL.append(" GROUP BY A.ID_HABITAT");
    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      filterSQL.append(_prepareWhereSort());
    }
    // Add the LIMIT clause to return only the wanted results
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
    }
    List tempList = new Vector();
    try {
      tempList = this.findWhere(filterSQL.toString());
    } catch (Exception _ex) {
      _ex.printStackTrace(System.err);
    }
    _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
    if (null == tempList) tempList = new Vector();
    return tempList;
  }

  /** Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
   * the sortCriteria[] array.
   * @return SQL representation of the sorting.
   */
  private StringBuffer _prepareWhereSort() {
    StringBuffer filterSQL = null;
    try {
      filterSQL = new StringBuffer();
      boolean useSort = false;
      if (sortCriteria.length > 0) {
        int i = 0;
        do {
          if (i > 0) filterSQL.append(", ");
          AbstractSortCriteria criteria = sortCriteria[i]; // Notice the upcast here
          if (!criteria.getCriteriaAsString().equals("none")) {// Do not add if criteria is sort to NOT SORT
            if (!criteria.getAscendencyAsString().equals("none")) { // Don't add if ascendency is set to none, nasty hacks
              filterSQL.append(criteria.toSQL());
              useSort = true;
            }
          }
          i++;
        } while (i < sortCriteria.length);
      }
      if (useSort) {// If a sort criteria was indeed used, then insert ORDER BY clause at the start of the string
        filterSQL.insert(0, " ORDER BY ");
      }
    } catch (InitializationException e) {
      e.printStackTrace();  //To change body of catch statement use Options | File Templates.
    } finally {
      return filterSQL;
    }
  }

  /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
   * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
   * @return The total number of results
   */
  public Long countResults() throws CriteriaMissingException {
    if (-1 == _resultCount.longValue()) {
      _resultCount = _rawCount();
    }
    return _resultCount;
  }


  /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
   * in your code that this method is called (in ideal way) only once and results are cached. This is what
   * countResults() method does in this class
   * @see ro.finsiel.eunis.jrfTables.species.country.RegionDomain#countResults
   * @return
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
   */
  private Long _rawCount() throws CriteriaMissingException {
    StringBuffer sql = new StringBuffer();
    // Set the main QUERY
    sql.append("SELECT COUNT(DISTINCT A.ID_HABITAT) FROM CHM62EDT_HABITAT AS A " +
            "INNER JOIN CHM62EDT_HABITAT_CLASS_CODE AS B ON A.ID_HABITAT = B.ID_HABITAT " +
            "INNER JOIN CHM62EDT_CLASS_CODE AS C ON B.ID_CLASS_CODE = C.ID_CLASS_CODE " +
            "WHERE ");
    // Apply WHERE CLAUSE
    sql.append(_prepareWhereSearch().toString());
    // Add query specific filetering...
    sql.append(" AND C.LEGAL = 1 ");
    Long ret = findLong(sql.toString());
    if (null == ret) return new Long(0);
    return ret;
  }


  /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
   * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
   * @return SQL string
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
   */
  private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
    StringBuffer filterSQL = new StringBuffer();
    if (searchCriteria.length <= 0) throw new CriteriaMissingException("No criteria set for searching. Search interrupted.");
    for (int i = 0; i < searchCriteria.length; i++) {
      if (i > 0) filterSQL.append(" AND ");
      AbstractSearchCriteria aCriteria = searchCriteria[i];

      filterSQL.append(aCriteria.toSQL());
    }
    filterSQL.append(" and IF(TRIM(A.CODE_2000) <> '',RIGHT(A.CODE_2000,2),1) <> IF(TRIM(A.CODE_2000) <> '','00',2) AND IF(TRIM(A.CODE_2000) <> '',LENGTH(A.CODE_2000),1) = IF(TRIM(A.CODE_2000) <> '',4,1) ");
    return filterSQL;
  }
}