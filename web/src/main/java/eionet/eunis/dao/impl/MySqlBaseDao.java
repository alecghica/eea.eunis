package eionet.eunis.dao.impl;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.ResourceBundle;

import ro.finsiel.eunis.utilities.ResultSetBaseReader;


public abstract class MySqlBaseDao {

    /**
     * Returns a new database connection.
     *
     * @throw ServiceException if no connections were available.
     */
    public static synchronized Connection getConnection() throws SQLException {

        Connection conn = null;

        try {
            ResourceBundle props = ResourceBundle.getBundle("jrf");
            String dbDriver = props.getString("mysql.driver");
            String dbUrl = props.getString("mysql.url");
            String dbUser = props.getString("mysql.user");
            String dbPass = props.getString("mysql.password");

            Class.forName(dbDriver);
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        } catch (Throwable e) {
            System.err.println(e.getMessage());
        }
        return conn;
    }

    public static void closeAllResources(Connection conn, Statement pstmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if ((conn != null) && (!conn.isClosed())) {
                conn.close();
                conn = null;
            }
        } catch (SQLException sqle) {}
    }

    public static void closeConnection(Connection conn) {
        try {
            if ((conn != null) && (!conn.isClosed())) {
                conn.close();
                conn = null;
            }
        } catch (SQLException sqle) {
            sqle.printStackTrace();
        }
    }

    public static void commit(Connection conn) {
        try {
            conn.commit();
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void rollback(Connection conn) {
        try {
            conn.rollback();
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected java.sql.Date sqlDate(Date date) {
        if (date == null) {
            return null;
        }
        return new java.sql.Date(date.getTime());

    }

    /**
     *
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
     *
     * @param parameterizedSQL
     * @param values
     * @param rsReader
     * @param conn
     * @throws SQLException
     */
    public <T> void executeQuery(String parameterizedSQL, List<Object> values, ResultSetBaseReader<T> rsReader)
        throws SQLException {
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection con = null;

        try {

            con = getConnection();

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
        } catch (Exception e) {
            e.printStackTrace();
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
            } catch (SQLException e) {}
        }
    }

    /**
     * Executes a SELECT sql and returns the first value.
     *
     * @param SQL SQL.
     * @return First column.
     */
    public String ExecuteSQL(String SQL) {
        if (SQL == null || SQL.trim().length() <= 0) {
            return "";
        }

        String result = "";

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement(SQL);
            rs = ps.executeQuery();

            if (rs.next()) {
                result = rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        } finally {
            closeAllResources(con, ps, rs);
        }
        return result;
    }

    /**
     * Executes parameterized sql query and return list of results.
     * Note! only first column in query is returned.
     * @param sql - sql string
     * @param params - sql parameters
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
                resultList.add((T) result.getObject(1));
            }
            return resultList;
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        } finally {
            closeAllResources(connection, prepared, result);
        }
    }
}
