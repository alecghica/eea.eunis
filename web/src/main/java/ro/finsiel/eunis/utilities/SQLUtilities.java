package ro.finsiel.eunis.utilities;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import ro.finsiel.eunis.dataimport.ColumnDTO;
import ro.finsiel.eunis.dataimport.ImportLogDTO;
import eionet.eunis.dto.DoubleDTO;

/**
 * Created by IntelliJ IDEA. User: ancai Date: 03.03.2005 Time: 15:35:37 To change this template use File | Settings | File
 * Templates.
 */
public class SQLUtilities {
    private String SQL_DRV = "";
    private String SQL_URL = "";
    private String SQL_USR = "";
    private String SQL_PWD = "";
    private int SQL_LIMIT = 1000;
    private int resultCount = 0;
    private static final String INSERT_BOOKMARK =
        "INSERT INTO EUNIS_BOOKMARKS( USERNAME, BOOKMARK, DESCRIPTION ) VALUES( ?, ?, ?)";

    /**
     * SQL used for soundex search
     */
    public static String smartSoundex = "" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and phonetic = soundex('<name>')"
    + " and left(name,6) = left('<name>',6)" + " union" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and phonetic = soundex('<name>')"
    + " and left(name,5) = left('<name>',5)" + " union" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and phonetic = soundex('<name>')"
    + " and left(name,4) = left('<name>',4)" + " union" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and phonetic = soundex('<name>')"
    + " and left(name,3) = left('<name>',3)" + " union" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and phonetic = soundex('<name>')"
    + " and left(name,2) = left('<name>',2)" + " union" + " select name,phonetic,object_type" + " from `chm62edt_soundex`"
    + " where object_type = '<object_type>'" + " and left(phonetic,3) = left(soundex('<name>'),3)";

    /**
     * Creates a new SQLUtilities object.
     */
    public SQLUtilities() {
    }

    /**
     * Initialization method for this object.
     *
     * @param SQL_DRIVER_NAME
     *            JDBC driver.
     * @param SQL_DRIVER_URL
     *            JDBC url.
     * @param SQL_DRIVER_USERNAME
     *            JDBC username.
     * @param SQL_DRIVER_PASSWORD
     *            JDBC password.
     */
    public void Init(String SQL_DRIVER_NAME, String SQL_DRIVER_URL, String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD) {
        SQL_DRV = SQL_DRIVER_NAME;
        SQL_URL = SQL_DRIVER_URL;
        SQL_USR = SQL_DRIVER_USERNAME;
        SQL_PWD = SQL_DRIVER_PASSWORD;
    }

    /**
     * Limit the results computed.
     *
     * @param SQLLimit
     *            Limit.
     */
    public void SetSQLLimit(int SQLLimit) {
        SQL_LIMIT = SQLLimit;
    }

    /**
     * Executes parameterized sql query and return list of results. Note! only first column in query is returned.
     *
     * @param sql
     *            - sql string
     * @param params
     *            - sql parameters
     * @return
     * @throws SQLException
     */
    @SuppressWarnings("unchecked")
    public <T> List<T> executeQuery(String sql, List<Object> params) throws SQLException {
        Connection connection = null;
        PreparedStatement prepared = null;
        ResultSet result = null;

        try {
            connection = getConnection();
            List<T> resultList = new LinkedList<T>();

            prepared = prepareStatement(sql, params, connection);
            result = prepared.executeQuery();
            while (result.next()) {
                resultList.add((T)result.getObject(1));
            }
            return resultList;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        } finally {
            closeAll(connection, prepared, result);
        }
    }

    /**
     * Execute an sql.
     *
     * @param SQL
     *            SQL.
     * @param Delimiter
     *            LIMIT
     * @return result
     */
    public String ExecuteFilterSQL(String SQL, String Delimiter) {

        if (SQL == null || Delimiter == null || SQL.trim().length() <= 0) {
            return "";
        }

        String result = "";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            resultCount = 0;

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();
            result = "";
            while (rs.next()) {
                resultCount++;
                if (resultCount <= SQL_LIMIT) {
                    result += Delimiter + rs.getString(1) + Delimiter;
                    result += ",";
                }
            }

            if (result.length() > 0) {
                if (result.substring(result.length() - 1).equalsIgnoreCase(",")) {
                    result = result.substring(0, result.length() - 1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } finally {
            closeAll(con, ps, rs);
        }

        return result;
    }

    public Connection getConnection() {
        Connection con = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return con;
    }

    /**
     * Executes a SELECT sql and returns the first value.
     *
     * @param SQL
     *            SQL.
     * @return First column.
     */
    public ArrayList<String> SQL2Array(String SQL) {

        if (SQL == null || SQL.trim().length() <= 0) {
            return null;
        }

        ArrayList<String> result = new ArrayList<String>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();

            while (rs.next()) {
                result.add(rs.getString(1));
            }

            closeAll(con, ps, rs);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeAll(con, ps, rs);
        }

        return result;
    }

    /**
     * Executes a SELECT sql and returns the given two columns as object.
     *
     * @param SQL
     * @param firstColumn
     * @param secondColumn
     * @return list
     */
    public ArrayList<DoubleDTO> SQL2ListOfDoubles(String SQL, String firstColumn, String secondColumn) {

        if (SQL == null || SQL.trim().length() <= 0 || firstColumn == null || secondColumn == null) {
            return null;
        }

        ArrayList<DoubleDTO> result = new ArrayList<DoubleDTO>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();

            while (rs.next()) {
                DoubleDTO d = new DoubleDTO();
                d.setOne(rs.getString(firstColumn));
                d.setTwo(rs.getString(secondColumn));
                result.add(d);
            }

            closeAll(con, ps, rs);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeAll(con, ps, rs);
        }

        return result;
    }

    /**
     * Executes a SELECT sql and returns the first value.
     *
     * @param SQL
     *            SQL.
     * @return First column.
     */
    public String ExecuteSQL(String SQL) {

        if (SQL == null || SQL.trim().length() <= 0) {
            return "";
        }

        // System.out.println("SQL = " + SQL);

        String result = "";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = rs.getString(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } finally {
            closeAll(con, ps, rs);
        }

        return result;
    }


    /**
     * Executes a CREATE sql .
     *
     * @param SQL
     */
    public void UpdateSQL(String SQL) {

        if (SQL == null || SQL.trim().length() <= 0) {
            System.out.println("SQL is empty!");
        }
        // System.out.println("SQL = " + SQL);

        String result = "";

        Connection con = null;
        Statement statement = null;
        int updateQuery = 0;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            statement = con.createStatement();
            updateQuery = statement.executeUpdate(SQL);

            if (updateQuery != 0) {
                System.out.println("table is created successfully and " + updateQuery
                        + " row is inserted.");
            }

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            try {
                statement.close();
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    }



    /**
     * Executes a sql.
     *
     * @param SQL
     *            SQL.
     */
    public void ExecuteDirectSQL(String SQL) {

        if (SQL == null || SQL.trim().length() <= 0) {
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                ps.close();
                con.close();
            } catch (Exception ex) {
            }
        }
    }

    /**
     * @param parameterizedSQL
     * @param valueMap
     * @param conn
     * @return
     * @throws SQLException
     */
    private PreparedStatement prepareStatement(String parameterizedSQL, List<Object> values, Connection conn) throws SQLException {

        PreparedStatement pstmt = conn.prepareStatement(parameterizedSQL);

        for (int i = 0; values != null && i < values.size(); i++) {
            try {
                String val = (String) values.get(i);

                if (val != null && val.equals("NULL")) {
                    pstmt.setNull(i + 1, Types.NULL);
                } else {
                    pstmt.setObject(i + 1, values.get(i));
                }
            } catch (ClassCastException e) {
                pstmt.setObject(i + 1, values.get(i));
            }
        }
        return pstmt;
    }

    /**
     * Executes given parameterized SQL statement with the given parameter values, passing the result set rows to the given reader.
     * Uses connection created internally from arguments supplied via {@link #Init(String, String, String, String)}.
     *
     * @param parameterizedSQL The given parameterized SQL.
     * @param values The given SQL parameter values.
     * @param rsReader The given result set reader.
     * @throws SQLException When executing the query and traversing its result.
     */
    public void executeQuery(String parameterizedSQL, List<Object> values, ResultSetBaseReader rsReader) throws SQLException {

        try {
            Class.forName(SQL_DRV);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Unable to locate JDBC driver: " + SQL_DRV, e);
        }

        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection con = null;
        try {
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            pstmt = prepareStatement(parameterizedSQL, values, con);
            rs = pstmt.executeQuery();
            if (rs != null) {
                ResultSetMetaData rsMd = rs.getMetaData();

                if (rsMd != null && rsMd.getColumnCount() > 0) {
                    rsReader.setResultSetMetaData(rsMd);
                    while (rs.next()) {
                        rsReader.readRow(rs);
                    }
                }
            }
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
                if (rs != null) {
                    rs.close();
                }
                if (pstmt != null) {
                    pstmt.close();
                }
            } catch (SQLException e) {
                // Ignore closing exceptions.
            }
        }

    }

    /**
     * Execute an sql.
     *
     * @param SQL
     *            SQL.
     * @param noColumns
     *            Number of columns
     * @return list of sql results.
     */
    public List ExecuteSQLReturnList(String SQL, int noColumns) {

        if (SQL == null || SQL.trim().length() <= 0 || noColumns <= 0) {
            return new ArrayList();
        }

        List result = new ArrayList();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();

            while (rs.next()) {
                TableColumns columns = new TableColumns();
                List columnsValues = new ArrayList();

                for (int i = 1; i <= noColumns; i++) {
                    columnsValues.add(rs.getString(i));
                }
                columns.setColumnsValues(columnsValues);
                result.add(columns);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        } finally {
            closeAll(con, ps, rs);
        }
        return result;
    }

    public Hashtable<String, String> getHashtable(String sql_stmt) {

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rset = null;

        Hashtable<String, String> h = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            stmt = con.prepareStatement(sql_stmt);
            rset = stmt.executeQuery(sql_stmt);
            ResultSetMetaData md = rset.getMetaData();

            int colCnt = md.getColumnCount();

            while (rset.next()) {
                h = new Hashtable<String, String>();
                for (int i = 0; i < colCnt; ++i) {
                    String name = md.getColumnName(i + 1);
                    String value = rset.getString(i + 1);

                    if (value == null) {
                        value = "";
                    }
                    h.put(name, value);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(con, stmt, rset);
        }
        return h;
    }

    /**
     * Count search results.
     *
     * @return reusults count.
     */
    public int getResultCount() {
        return resultCount;
    }

    /**
     * Execute UPDATE statement
     *
     * @param tableName
     *            table name
     * @param columnName
     *            column update
     * @param columnValue
     *            new value for column
     * @param whereCondition
     *            WHERE condition
     * @return operation status
     */
    public boolean ExecuteUpdate(String tableName, String columnName, String columnValue, String whereCondition) {

        boolean result = true;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps =
                con.prepareStatement("UPDATE " + tableName + " SET " + columnName + " = '" + columnValue + "' WHERE 1=1"
                        + (whereCondition == null && whereCondition.trim().length() <= 0 ? "" : " AND " + whereCondition));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        } finally {
            closeAll(con, ps, null);
        }
        return result;
    }

    /**
     * Execute DELETE statement
     *
     * @param tableName
     *            table name
     * @param whereCondition
     *            WHERE
     * @return operation status
     */
    public boolean ExecuteDelete(String tableName, String whereCondition) {

        boolean result = true;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps =
                con.prepareStatement("DELETE FROM " + tableName + " WHERE 1=1"
                        + (whereCondition == null || whereCondition.trim().length() <= 0 ? "" : " AND " + whereCondition));
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        } finally {
            closeAll(con, ps, null);
        }
        return result;
    }

    /**
     * Insert bookmark functionality
     *
     * @param username
     *            username associated with that bookmark
     * @param bookmarkURL
     *            URL
     * @param description
     *            Short description displayed to the user
     * @return operation status
     */
    public boolean insertBookmark(String username, String bookmarkURL, String description) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            ps = con.prepareStatement(INSERT_BOOKMARK);
            ps.setString(1, username);
            ps.setString(2, bookmarkURL);
            ps.setString(3, description);
            ps.execute();
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
        return result;
    }

    /**
     * Execute INSERT statement
     *
     * @param tableName
     *            table name
     * @param tableColumns
     *            columns
     * @return operation status
     */
    public boolean ExecuteInsert(String tableName, TableColumns tableColumns) {

        if (tableName == null || tableName.trim().length() <= 0 || tableColumns == null || tableColumns.getColumnsNames() == null
                || tableColumns.getColumnsNames().size() <= 0 || tableColumns.getColumnsValues() == null
                || tableColumns.getColumnsValues().size() <= 0) {
            return false;
        }

        boolean result = true;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            String namesList = "";
            String valuesList = "";

            for (int i = 0; i < tableColumns.getColumnsNames().size(); i++) {
                namesList +=
                    (String) tableColumns.getColumnsNames().get(i)
                    + (i < tableColumns.getColumnsNames().size() - 1 ? "," : "");
                valuesList +=
                    "'" + (String) tableColumns.getColumnsValues().get(i) + "'"
                    + (i < tableColumns.getColumnsNames().size() - 1 ? "," : "");
            }

            ps = con.prepareStatement("INSERT INTO " + tableName + " ( " + namesList + " ) values ( " + valuesList + " ) ");

            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        } finally {
            closeAll(con, ps, null);
        }
        return result;
    }

    /**
     * Execute INSERT statement
     *
     * @param tableName
     *            table name
     * @param tableColumns
     *            columns
     * @return operation status
     */
    public List<String> ExecuteMultipleInsert(String tableName, List<TableColumns> tableRows) throws Exception {

        if (tableName == null || tableName.trim().length() <= 0 || tableRows == null || tableRows.size() <= 0) {
            return null;
        }

        List<String> result = new ArrayList<String>();

        Connection con = null;
        PreparedStatement ps = null;
        Statement st = null;
        String query = "";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            con.setAutoCommit(false);

            st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM " + tableName);
            ResultSetMetaData rsMeta = rs.getMetaData();

            List<String> mysqlColumnNames = new ArrayList<String>();
            int numberOfColumns = rsMeta.getColumnCount();

            for (int x = 1; x <= numberOfColumns; x++) {
                String columnName = rsMeta.getColumnName(x);

                mysqlColumnNames.add(columnName);
            }

            for (Iterator<TableColumns> it = tableRows.iterator(); it.hasNext();) {

                TableColumns tableColumns = it.next();
                String namesList = "";
                String valuesList = "";

                for (int i = 0; i < tableColumns.getColumnsNames().size(); i++) {
                    String columnName = (String) tableColumns.getColumnsNames().get(i);

                    if (columnName != null && !columnName.equals("")) {
                        columnName = "`" + columnName + "`";
                    }
                    String columnValue = (String) tableColumns.getColumnsValues().get(i);

                    namesList += columnName + (i < tableColumns.getColumnsNames().size() - 1 ? "," : "");
                    valuesList += "'" + columnValue + "'" + (i < tableColumns.getColumnsNames().size() - 1 ? "," : "");
                }

                List xmlColumnNames = tableColumns.getColumnsNames();

                for (Iterator<String> it2 = mysqlColumnNames.iterator(); it2.hasNext();) {
                    boolean exist = false;
                    String mysqlColumnName = it2.next();

                    for (Iterator it3 = xmlColumnNames.iterator(); it3.hasNext();) {
                        String xmlColumnName = (String) it3.next();

                        if (mysqlColumnName.equalsIgnoreCase(xmlColumnName)) {
                            exist = true;
                        }
                    }
                    if (!exist) {
                        namesList += ",`" + mysqlColumnName + "`";
                        valuesList += ", NULL";
                    }
                }

                query = "INSERT INTO " + tableName + " ( " + namesList + " ) values ( " + valuesList + " ) ";
                ps = con.prepareStatement(query);
                ps.execute();
            }
            con.commit();
        } catch (Exception e) {
            con.rollback();
            con.commit();
            throw new IllegalArgumentException(e.getMessage() + " for statement: " + query, e);
            // result.add(e.getMessage()+"<br/> SQL statement: "+query);
        } finally {
            st.close();
            closeAll(con, ps, null);
        }
        return result;
    }

    /**
     * Determines what tabs will be shown for given factsheet
     *
     * @param idNatureObject
     *            object from database
     * @param NatureObjectType
     *            type of object (species, habitats, sites)
     * @return List<String> list of column names that exist
     */
    public List<String> getExistingTabPages(String idNatureObject, String NatureObjectType) {

        List<String> existingTabs = new ArrayList<String>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String SQL = "SELECT *";
        SQL += " FROM CHM62EDT_TAB_PAGE_" + NatureObjectType.toUpperCase();
        SQL += " WHERE ID_NATURE_OBJECT=" + idNatureObject;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();
            ResultSetMetaData meta = rs.getMetaData();
            int colCnt = meta.getColumnCount();

            if (rs.next()) {
                for (int i = 1; i <= colCnt; i++) {
                    String colName = meta.getColumnName(i);
                    if (colName != null && !colName.equalsIgnoreCase("ID_NATURE_OBJECT")) {
                        boolean exists = rs.getString(colName).equalsIgnoreCase("Y");
                        if (exists) {
                            existingTabs.add(colName);
                        }
                    }
                }
            }
        } catch (Exception e) {// e.printStackTrace();
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }

        return existingTabs;
        // quick hack to display all tabs in factsheet
        // return false;
    }

    public static void closeAll(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public boolean DesignationHasSites(String idDesignation, String idGeoscope) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String strSQL = "SELECT COUNT(*) AS RECORD_COUNT";

        strSQL = strSQL + " FROM `chm62edt_sites`";
        strSQL =
            strSQL
            + " INNER JOIN `chm62edt_designations` ON (`chm62edt_sites`.ID_DESIGNATION = `chm62edt_designations`.ID_DESIGNATION AND `chm62edt_sites`.ID_GEOSCOPE = `chm62edt_designations`.ID_GEOSCOPE)";
        strSQL = strSQL + " WHERE `chm62edt_sites`.ID_DESIGNATION = '" + idDesignation + "'";
        strSQL = strSQL + " AND `chm62edt_sites`.ID_GEOSCOPE = " + idGeoscope;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(strSQL);
            rs = ps.executeQuery();

            rs.next();
            result = rs.getInt(1) > 0;
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    public boolean EunisHabitatHasChilds(String idCode) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String strSQL = "SELECT ID_HABITAT";

        strSQL = strSQL + " FROM CHM62EDT_HABITAT";
        strSQL = strSQL + " WHERE EUNIS_HABITAT_CODE LIKE '" + idCode + "%'";
        strSQL = strSQL + " AND LENGTH(EUNIS_HABITAT_CODE)>" + idCode.length();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(strSQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = true;
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    public boolean Annex1HabitatHasChilds(String idCode, String idCodeParent) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String strSQL = "SELECT ID_HABITAT";

        strSQL = strSQL + " FROM CHM62EDT_HABITAT";
        strSQL = strSQL + " WHERE CODE_2000 LIKE '" + idCode + "%'";
        strSQL = strSQL + " AND CODE_2000<>'" + idCodeParent + "'";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(strSQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = true;
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    public boolean SpeciesHasChildTaxonomies(String idCode) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String strSQL = "SELECT ID_TAXONOMY";

        strSQL = strSQL + " FROM CHM62EDT_TAXONOMY";
        strSQL = strSQL + " WHERE ID_TAXONOMY_PARENT = '" + idCode + "'";
        strSQL = strSQL + " AND ID_TAXONOMY<>'" + idCode + "'";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(strSQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = true;
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    public boolean SpeciesHasChildSpecies(String idCode) {
        boolean result = false;

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String strSQL = "SELECT ID_SPECIES";

        strSQL = strSQL + " FROM CHM62EDT_SPECIES";
        strSQL = strSQL + " WHERE ID_TAXONOMY = '" + idCode + "'";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement(strSQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = true;
            }
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return result;
    }

    public List<String> getAllChm62edtTableNames() {

        List<String> ret = new ArrayList<String>();
        Connection con = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            DatabaseMetaData meta = con.getMetaData();
            ResultSet rs = meta.getTables(null, null, null, new String[] {"TABLE"});

            ;

            while (rs.next()) {
                String tableName = rs.getString("TABLE_NAME");

                if (tableName != null && (tableName.startsWith("chm62edt") || tableName.startsWith("dc_"))) {
                    ret.add(tableName);
                }
            }

            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return ret;
    }

    public HashMap<String, ColumnDTO> getTableInfo(String tableName) {

        Connection con = null;
        HashMap<String, ColumnDTO> columns = new HashMap<String, ColumnDTO>();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM " + tableName);
            ResultSetMetaData rsMeta = rs.getMetaData();

            int numberOfColumns = rsMeta.getColumnCount();

            for (int x = 1; x <= numberOfColumns; x++) {
                String columnName = rsMeta.getColumnName(x);
                int columnType = rsMeta.getColumnType(x);
                int size = rsMeta.getColumnDisplaySize(x);
                int precision = rsMeta.getPrecision(x);
                int scale = rsMeta.getScale(x);
                boolean isSigned = rsMeta.isSigned(x);
                int isNullable = rsMeta.isNullable(x);

                ColumnDTO column = new ColumnDTO();

                column.setColumnName(columnName);
                column.setColumnType(columnType);
                column.setColumnSize(size);
                column.setPrecision(precision);
                column.setScale(scale);
                column.setSigned(isSigned);
                column.setNullable(isNullable);

                columns.put(columnName.toLowerCase(), column);
            }

            st.close();
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return columns;
    }

    public List<ColumnDTO> getTableInfoList(String tableName) {

        Connection con = null;
        List<ColumnDTO> columns = new ArrayList<ColumnDTO>();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM " + tableName);
            ResultSetMetaData rsMeta = rs.getMetaData();

            int numberOfColumns = rsMeta.getColumnCount();

            for (int x = 1; x <= numberOfColumns; x++) {
                String columnName = rsMeta.getColumnName(x);
                int columnType = rsMeta.getColumnType(x);
                int size = rsMeta.getColumnDisplaySize(x);
                int precision = rsMeta.getPrecision(x);
                int scale = rsMeta.getScale(x);
                boolean isSigned = rsMeta.isSigned(x);
                int isNullable = rsMeta.isNullable(x);

                ColumnDTO column = new ColumnDTO();

                column.setColumnName(columnName);
                column.setColumnType(columnType);
                column.setColumnSize(size);
                column.setPrecision(precision);
                column.setScale(scale);
                column.setSigned(isSigned);
                column.setNullable(isNullable);

                columns.add(column);
            }

            st.close();
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return columns;
    }

    public String getTableContentAsXML(String tableName) {

        Connection con = null;
        StringBuilder ret = new StringBuilder();

        String nl = "\n";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM " + tableName);
            ResultSetMetaData rsMeta = rs.getMetaData();
            int numberOfColumns = rsMeta.getColumnCount();

            while (rs.next()) {
                ret.append("<ROW>").append(nl);
                for (int x = 1; x <= numberOfColumns; x++) {
                    String columnName = rsMeta.getColumnName(x);
                    String value = rs.getString(columnName);
                    int columnType = rsMeta.getColumnType(x);
                    int size = rsMeta.getColumnDisplaySize(x);

                    if (columnType == Types.DATE) {
                        if (size == 4) {
                            if (value != null && value.length() > 4) {
                                value = value.substring(0, 4);
                            }
                        }
                    }
                    if (value == null) {
                        value = "NULL";
                    }

                    if (!value.equalsIgnoreCase("NULL") && !value.equals("")) {
                        ret.append("<").append(columnName).append(">").append(EunisUtil.replaceTagsExport(value)).append("</")
                        .append(columnName).append(">").append(nl);
                    }
                }
                ret.append("</ROW>").append(nl);
            }

            st.close();
            con.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return ret.toString();
    }

    /**
     * Execute INSERT statement
     *
     * @param message
     * @return operation status
     */
    public boolean addImportLogMessage(String message) {

        if (message == null) {
            return false;
        }

        boolean result = true;

        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            message = EunisUtil.replaceTagsImport(message);
            ps =
                con.prepareStatement("INSERT INTO EUNIS_IMPORT_LOG (MESSAGE, CUR_TIMESTAMP) values ( '" + message
                        + "', CURRENT_TIMESTAMP() ) ");
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        } finally {
            closeAll(con, ps, null);
        }
        return result;
    }

    public List<ImportLogDTO> getImportLogMessages() {

        List<ImportLogDTO> result = new ArrayList<ImportLogDTO>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps =
                con.prepareStatement("SELECT LOG_ID, MESSAGE, CUR_TIMESTAMP FROM EUNIS_IMPORT_LOG ORDER BY LOG_ID DESC LIMIT 100");
            rs = ps.executeQuery();

            while (rs.next()) {
                ImportLogDTO dto = new ImportLogDTO();

                dto.setId(rs.getString("LOG_ID"));
                dto.setMessage(rs.getString("MESSAGE"));
                dto.setTimestamp(rs.getString("CUR_TIMESTAMP"));
                result.add(dto);
            }

            closeAll(con, ps, rs);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeAll(con, ps, rs);
        }

        return result;
    }

    public List<String> getUrls() {
        List<String> ret = new ArrayList<String>();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<String> statements = new ArrayList<String>();

        statements.add("SELECT URL FROM DC_INDEX");
        statements.add("SELECT LINK_URL FROM CHM62EDT_GLOSSARY");
        statements.add("SELECT VALUE FROM CHM62EDT_SITE_ATTRIBUTES WHERE VALUE LIKE 'http://%'");
        statements.add("SELECT DATA_SOURCE FROM CHM62EDT_DESIGNATIONS WHERE DATA_SOURCE LIKE 'http://%'");

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            for (String stmt : statements) {
                ps = con.prepareStatement(stmt);
                rs = ps.executeQuery();
                while (rs.next()) {
                    String url = rs.getString(1);

                    if (url != null && url.length() > 0) {
                        int space = url.indexOf(" ");

                        if (space != -1) {
                            url = url.substring(0, space);
                        }

                        int br = url.indexOf("\n");

                        if (br != -1) {
                            url = url.substring(0, br);
                        }

                        ret.add(url);
                    }
                }
            }

            closeAll(con, ps, rs);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            closeAll(con, ps, rs);
        }

        return ret;
    }

    /**
     * Execute INSERT statement
     */
    public void runPostImportSitesScript(boolean cmd) {

        Connection con = null;
        PreparedStatement ps = null;
        SQLUtilities sqlc = new SQLUtilities();

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            sqlc.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

            ps =
                con.prepareStatement("UPDATE chm62edt_sites SET LATITUDE=-(LAT_DEG+(LAT_MIN*60+LAT_SEC)/3600.000) WHERE LATITUDE IS NULL AND LAT_NS='S' AND LAT_DEG IS NOT NULL");
            ps.execute();
            ps =
                con.prepareStatement("UPDATE chm62edt_sites SET LATITUDE=LAT_DEG+(LAT_MIN*60+LAT_SEC)/3600.000 WHERE LATITUDE IS NULL AND LAT_NS='N' AND LAT_DEG is NOT NULL");
            ps.execute();
            ps =
                con.prepareStatement("UPDATE chm62edt_sites SET LONGITUDE=-(LONG_DEG+(LONG_MIN*60+LONG_SEC)/3600.000) WHERE LONGITUDE IS NULL AND LONG_EW='W' AND LONG_DEG IS NOT NULL");
            ps.execute();
            ps =
                con.prepareStatement("UPDATE chm62edt_sites SET LONGITUDE=LONG_DEG+(LONG_MIN*60+LONG_SEC)/3600.000 WHERE LONGITUDE IS NULL AND LONG_EW='E' AND LONG_DEG IS NOT NULL");
            ps.execute();
        } catch (Exception e) {
            EunisUtil.writeLogMessage("ERROR occured while generating sites latitude/longitude values: " + e.getMessage(), cmd,
                    sqlc);
            e.printStackTrace();
        } finally {
            closeAll(con, ps, null);
        }
    }

    /**
     * Reconstruct the TAXONOMY_TREE
     */
    public void reconstructTaxonomyTree() {

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String tree = "";
        // ID of taxonomy that is updated
        String origId = "";

        try {
            Class.forName(SQL_DRV);
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

            ps = con.prepareStatement("SELECT ID_TAXONOMY, ID_TAXONOMY_PARENT, LEVEL, NAME FROM CHM62EDT_TAXONOMY LIMIT 100");
            rs = ps.executeQuery();
            while (rs.next()) {
                String id = rs.getString("ID_TAXONOMY");
                origId = id;
                String parent = rs.getString("ID_TAXONOMY_PARENT");
                String level = rs.getString("LEVEL");
                String name = rs.getString("NAME");
                tree = id + "*" + level + "*" + name;
                do {
                    ps = con.prepareStatement(
                    "SELECT ID_TAXONOMY, ID_TAXONOMY_PARENT, LEVEL, NAME FROM CHM62EDT_TAXONOMY WHERE ID_TAXONOMY = ?");
                    ps.setString(1, parent);
                    ResultSet rs2 = ps.executeQuery();
                    while (rs2.next()) {
                        id = rs2.getString("ID_TAXONOMY");
                        parent = rs2.getString("ID_TAXONOMY_PARENT");
                        level = rs2.getString("LEVEL");
                        name = rs2.getString("NAME");
                        tree = id + "*" + level + "*" + name + "," + tree;
                    }
                    rs2.close();
                } while (!id.equals(parent));

                // Update TAXONOMY_TREE
                ps = con.prepareStatement("UPDATE CHM62EDT_TAXONOMY SET TAXONOMY_TREE = ? WHERE ID_TAXONOMY = ?");
                ps.setString(1, tree);
                ps.setString(2, origId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(con, ps, rs);
        }
    }

}
