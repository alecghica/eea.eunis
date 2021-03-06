package ro.finsiel.eunis.jrfTables.sites.statistics;

import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.LongColumnSpec;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

public class StatisticsDomain extends AbstractDomain {

  /****/
  public PersistentObject newPersistentObject() {
    return new StatisticsPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_SITES");
    this.setReadOnly(true);
    this.setTableAlias("A");
    this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("RESPONDENT", "getRespondent", "setRespondent", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("MANAGER", "getManager", "setManager", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("COMPLEX_NAME", "getComplexName", "setComplexName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DISTRICT_NAME", "getDistrictName", "setDistrictName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("OWNERSHIP", "getOwnership", "setOwnership", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("HISTORY", "getHistory", "setHistory", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CHARACTER", "getCharacter", "setCharacter", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("MANAGEMENT_PLAN", "getManagementPlan", "setManagementPlan", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("IUCNAT", "getIucnat", "setIucnat", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESIGNATION_DATE", "getDesignationDate", "setDesignationDate", null));
    this.addColumnSpec(new StringColumnSpec("COMPILATION_DATE", "getCompilationDate", "setCompilationDate", null));
    this.addColumnSpec(new StringColumnSpec("PROPOSED_DATE", "getProposedDate", "setProposedDate", null));
    this.addColumnSpec(new StringColumnSpec("CONFIRMED_DATE", "getConfirmedDate", "setConfirmedDate", null));
    this.addColumnSpec(new StringColumnSpec("UPDATE_DATE", "getUpdateDate", "setUpdateDate", null));
    this.addColumnSpec(new StringColumnSpec("SPA_DATE", "getSpaDate", "setSpaDate", null));
    this.addColumnSpec(new StringColumnSpec("SAC_DATE", "getSacDate", "setSacDate", null));
    this.addColumnSpec(new StringColumnSpec("NATIONAL_CODE", "getNationalCode", "setNationalCode", null));
    this.addColumnSpec(new StringColumnSpec("NATURA_2000", "getNatura2000", "setNatura2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NUTS", "getNuts", "setNuts", DEFAULT_TO_NULL));
    this.addColumnSpec(new LongColumnSpec("AREA", "getArea", "setArea", null));
    this.addColumnSpec(new LongColumnSpec("LENGTH", "getLength", "setLength", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_EW", "getLongEW", "setLongEW", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_DEG", "getLongDeg", "setLongDeg", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_MIN", "getLongMin", "setLongMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_SEC", "getLongSec", "setLongSec", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_NS", "getLatNS", "setLatNS", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_DEG", "getLatDeg", "setLatDeg", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_MIN", "getLatMin", "setLatMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_SEC", "getLatSec", "setLatSec", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MEAN", "getAltMean", "setAltMean", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MAX", "getAltMax", "setAltMax", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ALT_MIN", "getAltMin", "setAltMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_NULL));

    OuterJoinTable natureObjectGeoscope = new OuterJoinTable("CHM62EDT_NATURE_OBJECT_GEOSCOPE B ", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(natureObjectGeoscope);

    OuterJoinTable country = new OuterJoinTable("CHM62EDT_COUNTRY C", "ID_GEOSCOPE", "ID_GEOSCOPE");
    country.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setAreaNameEn"));
    natureObjectGeoscope.addJoinTable(country);
  }

  public Long findLong(String sql) {
    return super.findLong(sql);
  }
}