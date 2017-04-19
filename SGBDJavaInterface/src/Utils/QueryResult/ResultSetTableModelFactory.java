/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils.QueryResult;

import Utils.QueryResult.ResultSetTableModel;
import System.DBConnector;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Mihaela
 */
public class ResultSetTableModelFactory {
    Connection connection;  // Holds the connection to the database

    /** The constructor method uses the arguments to create db Connection */
    public ResultSetTableModelFactory(){
        DBConnector dBConnector = DBConnector.getInstance();
        connection = dBConnector.getConnection();
    }

    /**
     * This method takes a SQL query, passes it to the database, obtains the
     * results as a ResultSet, and returns a ResultSetTableModel object that
     * holds the results in a form that the Swing JTable component can use.
     **/
    public ResultSetTableModel getResultSetTableModel(String query)
        throws SQLException
    {
	// If we've called close(), then we can't call this method
	if (connection == null)
	    throw new IllegalStateException("Connection already closed.");

	// Create a Statement object that will be used to excecute the query.
	// The arguments specify that the returned ResultSet will be 
	// scrollable, read-only, and insensitive to changes in the db.
	Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	// Run the query, creating a ResultSet
	ResultSet r = statement.executeQuery(query);
	// Create and return a TableModel for the ResultSet
	return new ResultSetTableModel(r);
    }

    /** 
     * Call this method when done with the factory to close the DB connection 
     **/
    public void close() {
	/*try { connection.close(); } // Try to close the connection
	catch (Exception e) {}      // Do nothing on error. At least we tried.
	connection = null; */
    }

    /** Automatically close the connection when we're garbage collected */
    protected void finalize() { close(); }
}
