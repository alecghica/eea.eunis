package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_DISTRIBUTION_STATUS.
 * @author finsiel
 **/
public class Chm62edtDistributionStatusDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtTrendPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_DISTRIBUTION_STATUS");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_DISTRIBUTION_STATUS", "getId", "setId",
                DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("Name", "getName", "setName",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_ZERO));
    }
}
