package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_HABITAT_HABITAT.
 * @author finsiel
 **/
public class Chm62edtHabitatHabitatDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatHabitatPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_HABITAT_HABITAT");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_HABITAT", "getIdHabitat",
                        "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_HABITAT_LINK",
                        "getIdHabitatLink", "setIdHabitatLink", DEFAULT_TO_ZERO,
                        NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("RELATION_TYPE", "getRelationType",
                        "setRelationType", DEFAULT_TO_EMPTY_STRING,
                        NATURAL_PRIMARY_KEY)));
    }
}
