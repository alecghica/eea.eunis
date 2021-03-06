package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * JRF table for CHM62EDT_HABITAT_REPORT_TYPE inner join CHM62EDT_HABITAT.
 * @author finsiel
 **/
public class Chm62edtHabitatReportTypeDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatReportTypePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_HABITAT_REPORT_TYPE");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_HABITAT", "getIdHabitat",
                        "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_TYPE",
                        "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO,
                        NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("REPORT_VALUE", "getReportValue",
                "setReportValue", DEFAULT_TO_NULL));

        JoinTable joinTable = new JoinTable("CHM62EDT_REPORT_TYPE",
                "ID_REPORT_TYPE", "ID_REPORT_TYPE");

        joinTable.addJoinColumn(
                new StringJoinColumn("LOOKUP_TYPE", "lookupType",
                "setLookupType"));
        joinTable.addJoinColumn(
                new StringJoinColumn("ID_LOOKUP", "IDLookup", "setIDLookup"));
        this.addJoinTable(joinTable);
    }
}
