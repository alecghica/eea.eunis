package ro.finsiel.eunis.factsheet.habitats;

import net.sf.jrf.exceptions.DatabaseException;
import org.apache.log4j.Logger;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.jrfTables.*;
import ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatCountryDomain;
import ro.finsiel.eunis.jrfTables.habitats.factsheet.HabitatLegalDomain;
import ro.finsiel.eunis.jrfTables.habitats.factsheet.OtherClassificationDomain;
import ro.finsiel.eunis.jrfTables.species.habitats.HabitatsNatureObjectReportTypeSpeciesDomain;
import ro.finsiel.eunis.jrfTables.species.habitats.HabitatsNatureObjectReportTypeSpeciesPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.SortList;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.factsheet.HabitatsSpeciesWrapper;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

/**
 * This is the factsheet generator for the habitat's factsheet.
 *
 * @author finsiel
 */
public class HabitatsFactsheet {
  /**
   * Retrieve Altitude information about habitat.
   */
  public static final Integer OTHER_INFO_ALTITUDE = new Integer( 0 );
  /**
   * Retrieve Chemistry information about habitat.
   */
  public static final Integer OTHER_INFO_CHEMISTRY = new Integer( 1 );
  /**
   * Retrieve Climate information about habitat.
   */
  public static final Integer OTHER_INFO_CLIMATE = new Integer( 2 );
  /**
   * Retrieve Coverage information about habitat.
   */
  public static final Integer OTHER_INFO_COVER = new Integer( 3 );
  /**
   * Retrieve Humidity information about habitat.
   */
  public static final Integer OTHER_INFO_HUMIDITY = new Integer( 4 );
  /**
   * Retrieve Impact information about habitat.
   */
  public static final Integer OTHER_INFO_IMPACT = new Integer( 5 );
  /**
   * Retrieve Light information about habitat.
   */
  public static final Integer OTHER_INFO_LIGHT = new Integer( 6 );
  /**
   * Retrieve Life form information about habitat.
   */
  public static final Integer OTHER_INFO_LIFEFORM = new Integer( 7 );
  /**
   * Retrieve Temperature information about habitat.
   */
  public static final Integer OTHER_INFO_TEMPERATURE = new Integer( 8 );
  /**
   * Retrieve Usage information about habitat.
   */
  public static final Integer OTHER_INFO_USAGE = new Integer( 9 );
  /**
   * Retrieve Water information about habitat.
   */
  public static final Integer OTHER_INFO_WATER = new Integer( 10 );
  /**
   * Retrieve Substrate information about habitat.
   */
  public static final Integer OTHER_INFO_SUBSTRATE = new Integer( 11 );
  /**
   * Retrieve Depth information about habitat.
   */
  public static final Integer OTHER_INFO_DEPTH = new Integer( 12 );
  /**
   * Retrieve Geomorphology information about habitat.
   */
  public static final Integer OTHER_INFO_GEOMORPH = new Integer( 13 );
  /**
   * Retrieve Species richness information about habitat.
   */
  public static final Integer OTHER_INFO_SPECIES_RICHNESS = new Integer( 18 );
  /**
   * Retrieve Exposure to human factors information about habitat.
   */
  public static final Integer OTHER_INFO_EXPOSURE = new Integer( 15 );
  /**
   * Retrieve Spatial information about habitat.
   */
  public static final Integer OTHER_INFO_SPATIAL = new Integer( 16 );
  /**
   * Retrieve Temporal information about habitat.
   */
  public static final Integer OTHER_INFO_TEMPORAL = new Integer( 17 );
  /**
   * Retrieve Salinity information about habitat.
   */
  public static final Integer OTHER_INFO_SALINITY = new Integer( 14 );

  /**
   * Defines an EUNIS habitat.
   */
  public static final Integer EUNIS_HABITAT = new Integer( 0 );

  /**
   * Defines an ANNEX I habitat.
   */
  public static final Integer ANNEX_I_HABITAT = new Integer( 1 );

  /**
   * Habitat ID for the habitat we're constructing the factsheet.
   */
  private String idHabitat = null;

  /**
   * ID nature object for this habitat.
   */
  public Integer idNatureObject = null;

  /**
   * Habitat JRF object from database (CHM62EDT_HABITAT).
   */
  private Chm62edtHabitatPersist habitat = null;

  /**
   * Logging system.
   */
  private static Logger logger = Logger.getLogger( HabitatsFactsheet.class );

  /**
   * Construct an new Factsheet for the specified habitat.
   *
   * @param idHabitat ID of the habitat. This parameter should never be null.
   */
  public HabitatsFactsheet( String idHabitat ) {
    if ( null == idHabitat )
    {
      habitat = null;
      return;
    }
    this.idHabitat = idHabitat;
    initHabitat();// Initialize the habitat object
    if ( null != habitat )
    {
      idNatureObject = habitat.getIdNatureObject();
    }
  }

  /**
   * Find a habitat using its ID (Column ID_HABITAT from CHM62EDT_HABITAT).
   * Initialize Chm62edtHabitatPersist object with info about specified habitat, or null if not found or exception.
   */
  private void initHabitat() {
    try
    {
      List list = new Chm62edtHabitatDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
      if ( list.size() > 0 )
      {
        habitat = ( Chm62edtHabitatPersist ) list.get( 0 );
      }
      else
      {
        logger.warn( "initHabitat(): No habitat with this ID=" + idHabitat + " was found." );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      habitat = null;
    }
  }

  /**
   * Retrieve international names for this habitat.
   *
   * @param englishName Habitat name.
   * @return Object which contains the international names.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public Chm62edtHabitatInternationalNamePersist getHabitatInternational( String englishName ) throws InitializationException {
    if ( null == englishName )
    {
      throw new InitializationException( "idHabitat was null. This is unacceptable." );
    }
    Chm62edtHabitatInternationalNamePersist ret = null;
    try
    {
      List list = new Chm62edtHabitatInternationalNameDomain().findWhere( "NAME_EN='" + englishName + "'" );
      if ( list.size() > 0 )
      {
        ret = ( Chm62edtHabitatInternationalNamePersist ) list.get( 0 );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = null;
    }
    return ret;
  }

  /**
   * Retrieve syntaxa for this habitat.
   *
   * @return Vector of SyntaxaWrapper objects, one for each habitat.
   * @throws InitializationException If idHabitat is null.
   */
  public Vector getHabitatSintaxa() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. This is unacceptable." );
    }
    Vector ret = new Vector();
    try
    {
      List list = new Chm62edtHabitatSyntaxaDomain().findWhere( "A.ID_HABITAT='" + idHabitat + "'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtHabitatSyntaxaPersist habSyn = ( Chm62edtHabitatSyntaxaPersist ) it.next();
        SyntaxaWrapper syntaxa = new SyntaxaWrapper();
        syntaxa.setRelation( habSyn.getRelationType() );
        syntaxa.setSource( habSyn.getSource() );
        syntaxa.setSourceAbbrev( habSyn.getSourceAbbrev() );
        syntaxa.setName( habSyn.getSyntaxaName() );
        syntaxa.setAuthor( habSyn.getSyntaxaAuthor() );
        syntaxa.setIdDc( habSyn.getIdDc() );
        ret.addElement( syntaxa );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = new Vector();
    }
    finally
    {
      return ret;
    }
  }

  /**
   * This method retrieves 'other information' available for this habitat.
   *
   * @param information What information to retrieve. Is one of the OTHER_INFO_* public fields declared above.
   * @return An list of HabitatOtherInfo objects with available data.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public List getOtherInfo( Integer information ) throws InitializationException {
    Vector results = new Vector();
    if ( null != information )
    {
      if ( 0 == information.compareTo( OTHER_INFO_ALTITUDE ) )
      {
        results = getHabitatAltZone();
      }
      if ( 0 == information.compareTo( OTHER_INFO_CHEMISTRY ) )
      {
        results = this.getHabitatChemistry();
      }
      if ( 0 == information.compareTo( OTHER_INFO_CLIMATE ) )
      {
        results = this.getHabitatClimate();
      }
      if ( 0 == information.compareTo( OTHER_INFO_COVER ) )
      {
        results = this.getHabitatCover();
      }
      if ( 0 == information.compareTo( OTHER_INFO_HUMIDITY ) )
      {
        results = this.getHabitatHumidity();
      }
      if ( 0 == information.compareTo( OTHER_INFO_IMPACT ) )
      {
        results = this.getHabitatImpact();
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIFEFORM ) )
      {
        results = this.getHabitatLifeForm();
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIGHT ) )
      {
        results = this.getHabitatLightIntensity();
      }
      if ( 0 == information.compareTo( OTHER_INFO_SUBSTRATE ) )
      {
        results = this.getHabitatSubstrate();
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPERATURE ) )
      {
        results = this.getHabitatTemperature();
      }
      if ( 0 == information.compareTo( OTHER_INFO_USAGE ) )
      {
        results = this.getHabitatUsage();
      }
      if ( 0 == information.compareTo( OTHER_INFO_WATER ) )
      {
        results = this.getHabitatWater();
      }
      if ( 0 == information.compareTo( OTHER_INFO_DEPTH ) )
      {
        results = this.getHabitatDepth();
      }
      if ( 0 == information.compareTo( OTHER_INFO_GEOMORPH ) )
      {
        results = this.getHabitatGeomorph();
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPECIES_RICHNESS ) )
      {
        results = this.getHabitatSpeciesRichness();
      }
      if ( 0 == information.compareTo( OTHER_INFO_EXPOSURE ) )
      {
        results = this.getHabitatExposure();
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPATIAL ) )
      {
        results = this.getHabitatSpatial();
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPORAL ) )
      {
        results = this.getHabitatTemporal();
      }
      if ( 0 == information.compareTo( OTHER_INFO_SALINITY ) )
      {
        results = this.getHabitatSalinity();
      }
    }
    return results;
  }

  /**
   * Generate the SQL required for OTHER INFO tab.
   * @param information Information to be retrieved
   * @return SQL statement
   * @throws InitializationException Incorrect initialization
   */
  public String getSQLForOtherInfo( Integer information ) throws InitializationException {
    String result =
      "SELECT count(*) " +
        " FROM CHM62EDT_NATURE_OBJECT_REPORT_TYPE A " +
        " INNER JOIN CHM62EDT_REPORT_TYPE B ON A.ID_REPORT_TYPE=B.ID_REPORT_TYPE " +
        " where A.ID_NATURE_OBJECT = " + idNatureObject +
        " AND B.LOOKUP_TYPE = ";

    if ( null != information )
    {
      if ( 0 == information.compareTo( OTHER_INFO_ALTITUDE ) )
      {
        result += "'altitude'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_CHEMISTRY ) )
      {
        result += "'chemistry'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_CLIMATE ) )
      {
        result += "'climate'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_COVER ) )
      {
        result += "'cover'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_HUMIDITY ) )
      {
        result += "'humidity'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_IMPACT ) )
      {
        result += "'impact'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIFEFORM ) )
      {
        result += "'life_form'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIGHT ) )
      {
        result += "'light_intensity'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SUBSTRATE ) )
      {
        result += "'substrate'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPERATURE ) )
      {
        result += "'temperature'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_USAGE ) )
      {
        result += "'usage'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_WATER ) )
      {
        result += "'water'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_DEPTH ) )
      {
        result += "'depth'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_GEOMORPH ) )
      {
        result += "'geomorph'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPECIES_RICHNESS ) )
      {
        result += "'species_richness'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_EXPOSURE ) )
      {
        result += "'exposure'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPATIAL ) )
      {
        result += "'spatial'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPORAL ) )
      {
        result += "'temporal'";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SALINITY ) )
      {
        result += "'salinity'";
      }
    }
    else
    {
      return "";
    }
    return result;
  }


  /**
   * This method retrieves 'other information' titles available for this habitat.
   *
   * @param information What information to retrieve. Is one of the OTHER_INFO_* public fields declared above.
   * @return An list of HabitatOtherInfo objects with available data.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public String getOtherInfoDescription( Integer information ) throws InitializationException {
    String results = "";
    if ( null != information )
    {
      if ( 0 == information.compareTo( OTHER_INFO_ALTITUDE ) )
      {
        results = "Altitude zones (terrestrial and marine)";
      }
      if ( 0 == information.compareTo( OTHER_INFO_CHEMISTRY ) )
      {
        results = "Acidity, salinity, trophic status";
      }
      if ( 0 == information.compareTo( OTHER_INFO_CLIMATE ) )
      {
        results = "Climate zones ";
      }
      if ( 0 == information.compareTo( OTHER_INFO_COVER ) )
      {
        results = "Percentage cover by vegetation";
      }
      if ( 0 == information.compareTo( OTHER_INFO_HUMIDITY ) )
      {
        results = "Characteristics of wetness/dryness";
      }
      if ( 0 == information.compareTo( OTHER_INFO_IMPACT ) )
      {
        results = "Human activities and impacts";
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIFEFORM ) )
      {
        results = "Dominant life forms";
      }
      if ( 0 == information.compareTo( OTHER_INFO_LIGHT ) )
      {
        results = "Light intensity";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SUBSTRATE ) )
      {
        results = "Substrate types";
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPERATURE ) )
      {
        results = "Characterising temperature";
      }
      if ( 0 == information.compareTo( OTHER_INFO_USAGE ) )
      {
        results = "Levels of habitat usage";
      }
      if ( 0 == information.compareTo( OTHER_INFO_WATER ) )
      {
        results = "Characteristics of water flow, source and quality";
      }
      if ( 0 == information.compareTo( OTHER_INFO_DEPTH ) )
      {
        results = "Marine depth zones, more detailed than altitude zones";
      }
      if ( 0 == information.compareTo( OTHER_INFO_GEOMORPH ) )
      {
        results = "Geomorphology types";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPECIES_RICHNESS ) )
      {
        results = "Species richness values";
      }
      if ( 0 == information.compareTo( OTHER_INFO_EXPOSURE ) )
      {
        results = "Exposure types";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SPATIAL ) )
      {
        results = "Spatial parameters of size and shape";
      }
      if ( 0 == information.compareTo( OTHER_INFO_TEMPORAL ) )
      {
        results = "Temporal parameters";
      }
      if ( 0 == information.compareTo( OTHER_INFO_SALINITY ) )
      {
        results = "Salinity values, for marine habitats only";
      }
    }
    return results;
  }


  /**
   * Retrieve Altitude information for this habitat.
   *
   * @return An vector of Chm62edtAltitudePersist objects containing altitude information.
   * @throws InitializationException If idHabitat is null.
   */
  public Vector getHabitatAltZone() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. This is unacceptable." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='altitude'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtAltitudeDomain().findWhere( "ID_ALTITUDE='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Retrieve Chemistry information for this habitat.
   *
   * @return An vector of Chm62edtChemistryPersist objects containing altitude information.
   * @throws InitializationException If idHabitat is null.
   */
  public Vector getHabitatChemistry() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. This is unacceptable." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='chemistry'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtChemistryDomain().findWhere( "ID_CHEMISTRY='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    return res;
  }

  /**
   * Return climate information for this habitat.
   *
   * @return Vector of Chm62edtClimatePersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatClimate() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='climate'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtClimateDomain().findWhere( "ID_CLIMATE='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }


  /**
   * Return impact information for this habitat.
   *
   * @return Vector of Chm62edtImpactPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatImpact() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='impact'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtImpactDomain().findWhere( "ID_IMPACT='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return temperature information for this habitat.
   *
   * @return Vector of Chm62edtTemperaturePersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatTemperature() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='temperature'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtTemperatureDomain().findWhere( "ID_TEMPERATURE='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return life form information for this habitat.
   *
   * @return Vector of Chm62edtLifeFormPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatLifeForm() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='life_form'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtLifeFormDomain().findWhere( "ID_LIFE_FORM='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }


  /**
   * Return light intensity information for this habitat.
   *
   * @return Vector of Chm62edtLightIntensityPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatLightIntensity() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='light_intensity'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtLightIntensityDomain().findWhere( "ID_LIGHT_INTENSITY='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return substrate information for this habitat.
   *
   * @return Vector of Chm62edtSubstratePersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatSubstrate() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='substrate'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtSubstrateDomain().findWhere( "ID_substrate='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return humidity information for this habitat.
   *
   * @return Vector of Chm62edtHumidityPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatHumidity() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='humidity'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtHumidityDomain().findWhere( "ID_HUMIDITY='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return usage information for this habitat.
   *
   * @return Vector of Chm62edtUsagePersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatUsage() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='usage'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtUsageDomain().findWhere( "ID_USAGE='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return impact information for this habitat.
   *
   * @return Vector of Chm62edtWaterPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatWater() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='water'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtWaterDomain().findWhere( "ID_WATER='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return coverage information for this habitat.
   *
   * @return Vector of Chm62edtCoverPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatCover() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='cover'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtCoverDomain().findWhere( "ID_COVER='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }


  /**
   * Return salinity information for this habitat.
   *
   * @return Vector of Chm62edtSalinityPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatSalinity() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='salinity'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtSalinityDomain().findWhere( "ID_SALINITY='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return depth information for this habitat.
   *
   * @return Vector of Chm62edtDepthPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatDepth() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='depth'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtDepthDomain().findWhere( "ID_DEPTH='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return geomorphology information for this habitat.
   *
   * @return Vector of Chm62edtImpactPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatGeomorph() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='geomorph'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtGeomorphDomain().findWhere( "ID_GEOMORPH='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return species richness information for this habitat.
   *
   * @return Vector of Chm62edtRichnessPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatSpeciesRichness() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='species_richness'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtRichnessDomain().findWhere( "ID_SPECIES_RICHNESS='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return exposure information for this habitat.
   *
   * @return Vector of Chm62edtImpactPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatExposure() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='exposure'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtExposureDomain().findWhere( "ID_EXPOSURE='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return spatial information for this habitat.
   *
   * @return Vector of Chm62edtSpatialPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatSpatial() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='spatial'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtSpatialDomain().findWhere( "ID_SPATIAL='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Return temporal information for this habitat.
   *
   * @return Vector of Chm62edtTemporalPersist objects.
   * @throws InitializationException If idHabitat was null while constructing this object.
   */
  public Vector getHabitatTemporal() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector res = new Vector();
    try
    {
      List list = new Chm62edtNatureObjectReportTypeDomain().findWhere( "ID_NATURE_OBJECT='" + idNatureObject + "' AND B.LOOKUP_TYPE='temporal'" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        Chm62edtNatureObjectReportTypePersist report = ( Chm62edtNatureObjectReportTypePersist ) it.next();
        List l1 = new Chm62edtTemporalDomain().findWhere( "ID_TEMPORAL='" + report.getIDLookup() + "'" );
        if ( l1.size() > 0 )
        {
          res.addElement( l1.get( 0 ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      res = new Vector();
    }
    finally
    {
      return res;
    }
  }

  /**
   * Retrieve description & owner information for a habitat (from CHM62EDT_HABITAT_DESCRIPTION) using
   * Chm62edtHabitatDescriptionDomain.
   *
   * @return Vector of DescriptionWrapper objects.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public Vector getDescrOwner() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector results = new Vector();
    try
    {
      List list = new Chm62edtHabitatDescriptionDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
      if ( list != null && list.size() > 0 )
      {
        for ( int i = 0; i < list.size(); i++ )
        {
          Chm62edtHabitatDescriptionPersist habitatDescr = ( Chm62edtHabitatDescriptionPersist ) list.get( i );
          results.addElement( new DescriptionWrapper( habitatDescr.getDescription(),
            habitatDescr.getLanguageName(),
            habitatDescr.getOwnerText(), habitatDescr.getIdDc() ) );
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Retrieve name in other languages for this habitat.
   *
   * @return Vector of Chm62edtHabitatInternationalNamePersist objects.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public List getInternationalNames() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    try
    {
      return new Chm62edtHabitatInternationalNameDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
    }
    return new Vector();
  }

  /**
   * Find the EUNIS_CODE & EUNIS_HABITAT_LEVEL associated with specified habitat.
   *
   * @param idHabitat ID of the habitat to retrieve data for
   * @return The encapsulated data. If no information found or error ocurred, new CodeLevelWrapper("na", new Integer(0)).
   * @throws InitializationException if idHabitat was null during object construction.
   */
  private CodeLevelWrapper findHabitatEunisCodeLevel( final Integer idHabitat ) throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    CodeLevelWrapper ret = null;
    try
    {
      List list = new Chm62edtHabitatDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
      if ( list.size() > 0 )
      {
        Chm62edtHabitatPersist habitat = ( Chm62edtHabitatPersist ) list.get( 0 );
        if ( null != habitat )
        {
          ret = new CodeLevelWrapper();
          ret.setCode( habitat.getEunisHabitatCode() );
          ret.setLevel( habitat.getHabLevel() );
          ret.setIdHabitat( habitat.getIdHabitat() );
        }
      }
      if ( null == ret )
      {
        ret = new CodeLevelWrapper();
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = new CodeLevelWrapper();
    }
    finally
    {
      return ret;
    }
  }

  /**
   * Find the scientific name (SCIENTIFIC_NAME) associated with a habitat.
   *
   * @param idHabitat ID of the habitat to retrieve data for.
   * @return Scientific name of the habitat or 'na' no habitat with this ID found.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  private String findScientificName( Integer idHabitat ) throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    String ret = "";
    try
    {
      List list = new Chm62edtHabitatDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
      if ( list.size() > 0 )
      {
        Chm62edtHabitatPersist habitat = ( Chm62edtHabitatPersist ) list.get( 0 );
        if ( null != habitat )
        {
          ret = habitat.getScientificName();
        }
      }
      if ( null == ret )
      {
        ret = "na";
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = "na";
    }
    return ret;
  }

  /**
   * Retrieve the relation of this habitat with other habitats.
   *
   * @return Vector of HabitatFactsheetRelWrapper objects.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public Vector getOtherHabitatsRelations() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector v = new Vector();
    List list = new Chm62edtHabitatHabitatDomain().findWhere( "ID_HABITAT='" + idHabitat + "'" );
    Iterator it = list.iterator();
    while ( it.hasNext() )
    {
      v.addElement( it.next() );
    }
    Vector res = new Vector();
    try
    {
      if ( v.size() > 1 )
      {
        // Remove duplicates from v vector
        for ( int i = 0; i < v.size() - 1; i++ )
        {
          Chm62edtHabitatHabitatPersist currHab = ( Chm62edtHabitatHabitatPersist ) v.get( i );
          boolean duplicate = false;
          for ( int j = i + 1; j < v.size(); j++ )
          {
            Chm62edtHabitatHabitatPersist comparHab = ( Chm62edtHabitatHabitatPersist ) v.get( j );
            int currentIdHab = Utilities.checkedStringToInt( currHab.getIdHabitat(), -1 );
            int comparIdHab = Utilities.checkedStringToInt( currHab.getIdHabitat(), -2 );
            if ( currentIdHab == comparIdHab )
            {
              if ( currHab.getIdHabitatLink().intValue() == comparHab.getIdHabitatLink().intValue() )
              {
                duplicate = true;
              }
            }
          }
          if ( !duplicate )
          {
            CodeLevelWrapper eunisCode = findHabitatEunisCodeLevel( currHab.getIdHabitatLink() );
            HabitatFactsheetRelWrapper aWrapper = new HabitatFactsheetRelWrapper();
            aWrapper.setEunisCode( eunisCode.getCode() );
            aWrapper.setRelation( currHab.getRelationType().equals( "A" ) ? "Ancestor" : "Parent" );
            aWrapper.setScientificName( findScientificName( currHab.getIdHabitatLink() ) );
            aWrapper.setCriteria( HabitatFactsheetRelWrapper.SORT_EUNIS_CODE );
            aWrapper.setLevel( eunisCode.getLevel() );
            aWrapper.setIdHabitat( eunisCode.getIdHabitat() );
            res.addElement( aWrapper );
          }
        }
        Chm62edtHabitatHabitatPersist lastHab = ( Chm62edtHabitatHabitatPersist ) v.get( v.size() - 1 );
        CodeLevelWrapper eunisCode = findHabitatEunisCodeLevel( lastHab.getIdHabitatLink() );
        HabitatFactsheetRelWrapper aWrapper = new HabitatFactsheetRelWrapper();
        aWrapper.setEunisCode( eunisCode.getCode() );
        aWrapper.setRelation( lastHab.getRelationType().equals( "A" ) ? "Ancestor" : "Parent" );
        aWrapper.setScientificName( findScientificName( lastHab.getIdHabitatLink() ) );
        aWrapper.setCriteria( HabitatFactsheetRelWrapper.SORT_EUNIS_CODE );
        aWrapper.setLevel( eunisCode.getLevel() );
        aWrapper.setIdHabitat( eunisCode.getIdHabitat() );
        res.addElement( aWrapper );
        // Sort results
        SortList sorter = new SortList();
        return sorter.sort( res, SortList.SORT_ASCENDING );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      return new Vector();
    }
    return new Vector();
  }

  /**
   * The representation of current habitat in other classifications.
   *
   * @return A List of OtherClassificationPersist objects.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public List getOtherClassifications() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    List result = new Vector();
    try
    {
      result = new OtherClassificationDomain().findWhere( "ID_HABITAT='" + idHabitat + "' AND LEGAL=0 ORDER BY SORT_ORDER" );
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      result = new Vector();
    }
    return result;
  }

  /**
   * Retrieve legal information for this habitat.
   *
   * @return An vector of HabitatLegalPersist objects.
   * @throws InitializationException if idHabitat was null during object construction.
   */
  public Vector getHabitatLegalInfo() throws InitializationException {
    if ( null == idHabitat )
    {
      throw new InitializationException( "idHabitat was null. Cannot retrieve information." );
    }
    Vector ret = new Vector();
    try
    {
      List list = new HabitatLegalDomain().findWhere( "C.LEGAL=1 AND A.ID_HABITAT='" + idHabitat + "' ORDER BY C.NAME, B.CODE" );
      Iterator it = list.iterator();
      while ( it.hasNext() )
      {
        ret.addElement( it.next() );
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = new Vector();
    }
    finally
    {
      return ret;
    }
  }

  /**
   * Retrieve the original database code for this habitat (ORIGINAL_CODE field from CHM62EDT_NATURE_OBJECT table).
   *
   * @return The original code or "na" if not found in database.
   */
  public String getOriginalCode() {
    String ret = "na";
    try
    {
      if ( null != habitat )
      {
        List list = new Chm62edtNatureObjectDomain().findWhere( "ID_NATURE_OBJECT='" + habitat.getIdNatureObject() + "'" );
        if ( !list.isEmpty() )
        {
          Chm62edtNatureObjectPersist natObj = ( Chm62edtNatureObjectPersist ) list.get( 0 );
          ret = natObj.getOriginalCode();
        }
      }
    }
    catch ( Exception ex )
    {
      ex.printStackTrace( System.err );
      ret = "na";
    }
    finally
    {
      return ret;
    }
  }

  /**
   * Used for habitat geographical distribution to retrieve probability and comment columns information.
   * Uses CHM62EDT_REPORT_ATTRIBUTES table.
   *
   * @param idReportAttribute ID_REPORT_ATTRIBUTES for the country.
   * @return Vector with two String elements: probability, comment.
   */
//  public static Vector getProbabilityAndCommentForHabitatGeoscope(Integer idReportAttribute) {
//    Vector result = new Vector();
//    String probability = "";
//    String comment = "";
//    try {     System.out.println("idReportAttribute="+idReportAttribute);
//      List attributes = new Chm62edtReportAttributesDomain().findWhere("ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND (NAME='PROBABILITY' OR NAME='COMMENT')");
//      if (attributes != null && attributes.size() > 0) {
//        probability = ((Chm62edtReportAttributesPersist) attributes.get(0) != null ?
//                (((Chm62edtReportAttributesPersist) attributes.get(0)).getName().equalsIgnoreCase("probability") ?
//                ((Chm62edtReportAttributesPersist) attributes.get(0)).getValue()
//                : "1")
//                : "2");
//
//        comment = ((Chm62edtReportAttributesPersist) attributes.get(0) != null ?
//                (((Chm62edtReportAttributesPersist) attributes.get(0)).getName().equalsIgnoreCase("comment") ?
//                ((Chm62edtReportAttributesPersist) attributes.get(0)).getValue()
//                : "3")
//                : "4");
//
//        if (attributes.size() > 1) {
//          probability = ((Chm62edtReportAttributesPersist) attributes.get(1) != null ?
//                  (((Chm62edtReportAttributesPersist) attributes.get(1)).getName().equalsIgnoreCase("probability") ?
//                  ((Chm62edtReportAttributesPersist) attributes.get(1)).getValue()
//                  : "5")
//                  : "6");
//
//          comment = ((Chm62edtReportAttributesPersist) attributes.get(1) != null ?
//                  (((Chm62edtReportAttributesPersist) attributes.get(1)).getName().equalsIgnoreCase("comment") ?
//                  ((Chm62edtReportAttributesPersist) attributes.get(1)).getValue()
//                  : "7")
//                  : "8");
//        }
//      }
//    } catch (Exception e) {
//      e.printStackTrace();
//    }
//
//    result.addElement(probability);
//    result.addElement(comment);
//
//    return result;
//  }
  public static Vector getProbabilityAndCommentForHabitatGeoscope( Integer idReportAttribute ) {
    Vector result = new Vector();
    String probability = "";
    String comment = "";
    try
    {
      List attributes = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND (NAME='PROBABILITY' OR NAME='COMMENT')" );
      if ( attributes != null && attributes.size() > 0 )
      {
        if ( attributes.size() > 1 )
        {
          probability = ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) != null &&
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getName().equalsIgnoreCase( "probability" ) ?
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getValue()
            : ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) != null &&
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) ).getName().equalsIgnoreCase( "probability" ) ?
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) ).getValue() : "" ) );

          comment = ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) != null &&
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getName().equalsIgnoreCase( "comment" ) ?
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getValue()
            : ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) != null &&
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) ).getName().equalsIgnoreCase( "comment" ) ?
            ( ( Chm62edtReportAttributesPersist ) attributes.get( 1 ) ).getValue() : "" ) );
        }
        else
        {
          probability = ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) != null ?
            ( ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getName().equalsIgnoreCase( "probability" ) ?
              ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getValue()
              : "" )
            : "" );

          comment = ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) != null ?
            ( ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getName().equalsIgnoreCase( "comment" ) ?
              ( ( Chm62edtReportAttributesPersist ) attributes.get( 0 ) ).getValue()
              : "" )
            : "" );
        }
      }
    }
    catch ( Exception e )
    {
      e.printStackTrace();
    }

    result.addElement( probability );
    result.addElement( comment );

    return result;
  }

  /**
   * Find all the countries where a habitat is located.
   *
   * @return A list with HabitatCountryPersist objects.
   */
  public List getHabitatCountries() {
    List ret = new Vector();
    try
    {
      ret = new HabitatCountryDomain().findWhere( "A.ID_NATURE_OBJECT='" + habitat.getIdNatureObject() + "' GROUP BY C.ID_GEOSCOPE,D.ID_GEOSCOPE" );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
      ret = new Vector();
    }
    finally
    {
      return ret;
    }
  }

  /**
   * Mapping between relation simbols an human readable text.
   *
   * @param relation Relation (supported are: '<', ">', '=', '#', '?', 's').
   * @return Decoded relation, in human readable language (narrower, wider, same, overlap, not defined, source).
   */
  public static String mapHabitatsRelations( String relation ) {
    if ( null == relation )
    {
      return "n/a";
    }
    if ( relation.equalsIgnoreCase( "<" ) )
    {
      return "narrower";
    }
    if ( relation.equalsIgnoreCase( ">" ) )
    {
      return "wider";
    }
    if ( relation.equalsIgnoreCase( "=" ) )
    {
      return "same";
    }
    if ( relation.equalsIgnoreCase( "#" ) )
    {
      return "overlap";
    }
    if ( relation.equalsIgnoreCase( "?" ) )
    {
      return "not defined";
    }
    if ( relation.equalsIgnoreCase( "s" ) )
    {
      return "source";
    }
    if ( relation.equalsIgnoreCase( "" ) )
    {
      return "n/a";
    }
    return relation;
  }

  /**
   * Find the ID_NATURE_OBJECT for a habitat.
   *
   * @param idHabitat ID of the habitat.
   * @return ID_NATURE_OBJECT.
   */
  public static int getIdNoForHabitat( String idHabitat ) {
    if ( null == idHabitat )
    {
      return -1;
    }
    try
    {
      List list = new Chm62edtHabitatDomain().findWhere( "ID_HABITAT=" + idHabitat );
      if ( list != null && list.size() > 0 )
      {
        Chm62edtHabitatPersist habitat = ( ( Chm62edtHabitatPersist ) list.get( 0 ) );
        if ( null != habitat )
        {
          return habitat.getIdNatureObject().intValue();
        }
      }
      else
      {
        return -1;
      }
    }
    catch ( DatabaseException _ex )
    {
      logger.error( "getidNoForHabitat(): Could not find habitat due to database exception: " + _ex.getMessage() );
    }
    return -1;
  }

  /**
   * Retrieve the DESCRIPTION for this habitat from database.
   *
   * @return Description string.
   */
  public String getHabitatDescription() {
    String description = ( null != habitat ) ? habitat.getDescription() : null;
    if ( null == description )
    {
      description = "na";
    }
    else if ( description.equalsIgnoreCase( "" ) )
    {
      description = "na";
    }
    return description;
  }

  /**
   * Retrieve the SCIENTIFIC_NAME for this habitat from database.
   *
   * @return Scientific name.
   */
  public String getHabitatScientificName() {
    String sciName = ( null != habitat ) ? habitat.getScientificName() : null;
    if ( null == sciName )
    {
      sciName = "na";
    }
    return sciName;
  }

  /**
   * This methods finds if an habitat is EUNIS or ANNEX I.
   *
   * @return EUNIS_HABITAT or ANNEX_I_HABITAT.
   */
  public Integer getHabitatType() {
    return Utilities.getHabitatType( habitat.getCodeAnnex1() );
  }

  /**
   * Check if this habitat is EUNIS.
   *
   * @return true if EUNIS.
   */
  public boolean isEunis() {
    //if (0 == EUNIS_HABITAT.compareTo(getHabitatType())) return true;
    int idHabitat = Utilities.checkedStringToInt( habitat.getIdHabitat(), -1 );
    return ( idHabitat > 10000 ) ? false : true;
  }

  /**
   * Check if habitat is EUNIS.
   * @param idHab habitat ID
   * @return True for EUNIS habitats
   */
  public static boolean isEunis( String idHab ) {
    int id = Utilities.checkedStringToInt( idHab, -1 );
    return ( id > 10000 ) ? false : true;
  }

  /**
   * Check if this habitat is ANNEX I.
   *
   * @return true if ANNEX I.
   */
  public boolean isAnnexI() {
    if ( 0 == ANNEX_I_HABITAT.compareTo( getHabitatType() ) )
    {
      return true;
    }
    return false;
  }

  /**
   * Return the LEVEL from database for this habitat.
   *
   * @return Level. Only EUNIS habitats have level, other have level = 0.
   */
  public Integer getHabitatLevel() {
    Integer level = ( null != habitat ) ? habitat.getHabLevel() : null;
    if ( null == level )
    {
      level = new Integer( 0 );
    }
    return level;
  }

  /**
   * Get the EUNIS_HABITAT_CODE associated with this habitat.
   *
   * @return Eunis code.
   */
  public String getEunisHabitatCode() {
    String eunisCode = ( null != habitat ) ? habitat.getEunisHabitatCode() : null;
    if ( null == eunisCode )
    {
      eunisCode = "na";
    }
    return eunisCode;
  }

  /**
   * Get the PRIORITY associated with this habitat.
   *
   * @return The priority or 0 if not available.
   */
  public Short getPriority() {
    Short priority = ( null != habitat ) ? habitat.getPriority() : null;
    if ( null == priority )
    {
      priority = new Short( "0" );
    }
    return priority;
  }

  /**
   * Retrieve the CODE_2000 associated with this habitat.
   *
   * @return Code 2000.
   */
  public String getCode2000() {
    String code2000 = ( null != habitat ) ? habitat.getCode2000() : null;
    if ( null == code2000 )
    {
      code2000 = "na";
    }
    return code2000;
  }

  /**
   * Retrieve the CODE_ANNEX1 associated with this habitat.
   *
   * @return ANNEX I code.
   */
  public String getCodeAnnex1() {
    String codeannex1 = ( null != habitat ) ? habitat.getCodeAnnex1() : null;
    if ( null == codeannex1 )
    {
      codeannex1 = "na";
    }
    return codeannex1;
  }

  /**
   * Find attribute information about this habitat (from CHM62EDT_REPORT_ATTRIBUTES table).
   *
   * @param idReportAttribute ID of the atrribute (ID_REPORT_ATTRIBUTES column from the table).
   * @param name              Name of the attribute to retrieve (NAME column from the table).
   * @return String with VALUE associated with the NAME (VALUE column from the table).
   */
  private static String findReportAttributesValue( Integer idReportAttribute, String name ) {
    String result = "";
    try
    {
      List results = new Chm62edtReportAttributesDomain().findWhere( "ID_REPORT_ATTRIBUTES='" + idReportAttribute + "' AND NAME='" + name + "'" );
      if ( null != results && results.size() > 0 )
      {
        result = ( ( Chm62edtReportAttributesPersist ) results.get( 0 ) ).getValue();
      }
      else
      {
        result = "";
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    finally
    {
      return result;
    }
  }

  /**
   * Find a value from CHM62EDT_REPORT_TYPE table.
   *
   * @param idReportType ID_REPORT_TYPE column from table.
   * @param lookup_type  LOOKUP_TYPE column from the table (currently implemented are: abundance, frequencies,
   *                     faithfulness, species_status).
   * @return String with VALUE for this attribute from the associated table (ex. abundance is associated with
   *         CHM62EDT_ABUNDANCE. Give the name and will return the VALUE from that table).
   */
  private static String findReportTypeValue( Integer idReportType, String lookup_type ) {
    String result = "";
    String idLookup = "";
    try
    {
      List results = new Chm62edtReportTypeDomain().findWhere( "ID_REPORT_TYPE='" + idReportType + "' AND LOOKUP_TYPE='" + lookup_type + "'" );
      if ( null != results && results.size() > 0 )
      {
        idLookup = ( ( Chm62edtReportTypePersist ) results.get( 0 ) ).getIdLookup();
      }
      else
      {
        idLookup = "";
      }
      if ( lookup_type.equalsIgnoreCase( "abundance" ) )
      {
        results = new Chm62edtAbundanceDomain().findWhere( "ID_ABUNDANCE='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtAbundancePersist ) results.get( 0 ) ).getDescription();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "frequencies" ) )
      {
        results = new Chm62edtFrequenciesDomain().findWhere( "ID_FREQUENCIES='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtFrequenciesPersist ) results.get( 0 ) ).getName();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "faithfulness" ) )
      {
        results = new Chm62edtFaithfulnessDomain().findWhere( "ID_FAITHFULNESS='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtFaithfulnessPersist ) results.get( 0 ) ).getName();
        }
        else
        {
          result = "";
        }
      }
      if ( lookup_type.equalsIgnoreCase( "species_status" ) )
      {
        results = new Chm62edtSpeciesStatusDomain().findWhere( "ID_SPECIES_STATUS='" + idLookup + "'" );
        if ( null != results && results.size() > 0 )
        {
          result = ( ( Chm62edtSpeciesStatusPersist ) results.get( 0 ) ).getDescription();
        }
        else
        {
          result = "";
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    finally
    {
      return result;
    }
  }

  /**
   * Retrieve the species living in this habitat.
   *
   * @return List of HabitatsSpeciesWrapper objects.
   */
  public List getSpeciesForHabitats() {
    Vector results = new Vector();
    List species = null;
    try
    {
      species = new HabitatsNatureObjectReportTypeSpeciesDomain().findWhere( "H.ID_HABITAT<>'-1' AND H.ID_HABITAT<>'10000' AND H.ID_NATURE_OBJECT = " + idNatureObject + " GROUP BY C.ID_NATURE_OBJECT ORDER BY C.SCIENTIFIC_NAME" );
      if ( species != null )
      {
        for ( int i = 0; i < species.size(); i++ )
        {
          HabitatsNatureObjectReportTypeSpeciesPersist specie = ( HabitatsNatureObjectReportTypeSpeciesPersist ) species.get( i );
          String abundance = findReportTypeValue( specie.getIdReportType(), "abundance" );
          String frequencies = findReportTypeValue( specie.getIdReportType(), "frequencies" );
          String faithfulness = findReportTypeValue( specie.getIdReportType(), "faithfulness" );
          String speciesStatus = findReportTypeValue( specie.getIdReportType(), "species_status" );
          String comment = findReportAttributesValue( specie.getIdReportAttributes(), "comment" );
          String geoscope = CountryUtil.findBiogeoregionByIDGeoscope( specie.getIdGeoscope() );
          results.addElement( new HabitatsSpeciesWrapper( specie.getIdSpecies(),
            specie.getIdSpeciesLink(),
            specie.getSpeciesScientificName(),
            geoscope,
            abundance,
            frequencies,
            faithfulness,
            speciesStatus,
            comment ) );
        }
      }
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
    }
    return results;
  }

  /**
   * Retrieve the pictures available for this habitat.
   *
   * @return List of Chm62edtNatureObjectPicturePersist objects.
   */
  public List getPicturesForHabitats() {
    List results = new Vector();
    String where = "";
    Chm62edtNatureObjectPictureDomain nop = new Chm62edtNatureObjectPictureDomain();
    where += " ID_OBJECT='" + habitat.getIdHabitat() + "'";
    where += " AND NATURE_OBJECT_TYPE='Habitats'";
    try
    {
      results = nop.findWhere( where );
    }
    catch ( Exception _ex )
    {
      _ex.printStackTrace( System.err );
      results = new Vector();
    }
    return results;
  }

  /**
   * Getter for idHabitat. Provides access to the ID of the current habitat.
   *
   * @return Value for idHabitat, null if this habitat is invalid (none existed in database with id given in ctor)
   */
  public String getIdHabitat() {
    return idHabitat;
  }

  /**
   * Getter for the habitat object. Provides access to the current habitat.
   *
   * @return Database representation of this habitat.
   */
  public Chm62edtHabitatPersist getHabitat() {
    return habitat;
  }
}