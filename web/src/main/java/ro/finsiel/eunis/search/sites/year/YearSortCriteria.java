package ro.finsiel.eunis.search.sites.year;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria used for sites->year.
 * @author finsiel
 */
public class YearSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by source db.
     */
    public static final Integer SORT_SOURCE_DB = new Integer(1);

    /**
     * Sort by country.
     */
    public static final Integer SORT_COUNTRY = new Integer(3);

    /**
     * Sort by name.
     */
    public static final Integer SORT_NAME = new Integer(4);

    /**
     * Sort by size.
     */
    public static final Integer SORT_SIZE = new Integer(2);

    /**
     * Sort by designation type.
     */
    public static final Integer SORT_DESIGN = new Integer(5);

    /**
     * Sort by latitude.
     */
    public static final Integer SORT_LAT = new Integer(6);

    /**
     * Sort by longitude.
     */
    public static final Integer SORT_LONG = new Integer(7);

    /**
     * Sort by year.
     */
    public static final Integer SORT_YEAR = new Integer(8);

    /**
     * Ctor.
     * @param sortCriteria Criteria used for sorting.
     * @param ascendency Ascendency.
     */
    public YearSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_SOURCE_DB, "A.SOURCE_DB");
        possibleSorts.put(SORT_NAME, "A.NAME");
        possibleSorts.put(SORT_SIZE, "A.AREA"); // Order
        possibleSorts.put(SORT_COUNTRY, "C.AREA_NAME_EN"); // Order
        possibleSorts.put(SORT_DESIGN, "E.DESCRIPTION"); // Order
        possibleSorts.put(SORT_LAT,
                "IF(A.LAT_NS='N',IF(A.LAT_DEG IS NULL,0,A.LAT_DEG)*3600 + IF(A.LAT_MIN IS NULL,0,A.LAT_MIN)*60 + IF(A.LAT_SEC IS NULL,0,A.LAT_SEC),(-1)*(IF(A.LAT_DEG IS NULL,0,A.LAT_DEG)*3600 + IF(A.LAT_MIN IS NULL,0,A.LAT_MIN)*60 + IF(A.LAT_SEC IS NULL,0,A.LAT_SEC)))"); // Order
        possibleSorts.put(
                SORT_LONG,
                "IF(A.LONG_EW='E',IF(A.LONG_DEG IS NULL,0,A.LONG_DEG)*3600 +IF(A.LONG_MIN IS NULL,0,A.LONG_MIN)*60 + IF(A.LONG_SEC IS NULL,0,A.LONG_SEC),(-1)*(IF(A.LONG_DEG IS NULL,0,A.LONG_DEG) *3600 + IF(A.LONG_MIN IS NULL,0,A.LONG_MIN)*60 + IF(A.LONG_SEC IS NULL,0,A.LONG_SEC)))"); // Order
        possibleSorts.put(
                SORT_YEAR,
                "CAST(CONCAT(" + "IF(A.source_db='BIOGENETIC',left(designation_date,4),''),"
                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='EMERALD',right(designation_date,4),''),"
                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''),"
                + "IF(A.source_db='NATURA2000',right(designation_date,4),''),"
                + "IF(A.source_db='CORINE',right(designation_date,4),''),"
                + "IF(A.source_db='NATURENET',right(designation_date,4),'')" + ") AS SIGNED)");
    }
}
