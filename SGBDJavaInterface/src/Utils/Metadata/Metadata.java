/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils.Metadata;

import System.DBConnector;
import System.SystemManager;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Mihaela
 */
public class Metadata {

    static DBConnector dBConnector = DBConnector.getInstance();
    static Connection connection = dBConnector.getConnection();
    static DatabaseMetaData metadata = null;
    // Static block for initialization

    static {
        try {
            metadata = connection.getMetaData();
        } catch (SQLException e) {
            System.err.println("There was an error getting the metadata: "
                    + e.getMessage());
        }
    }

    /**
     * Prints in the console the general metadata.
     *
     * @throws SQLException
     */
    public static void printGeneralMetadata() throws SQLException {
        System.out.println("Database Product Name: "
                + metadata.getDatabaseProductName());
        System.out.println("Database Product Version: "
                + metadata.getDatabaseProductVersion());
        System.out.println("Logged User: " + metadata.getUserName());
        System.out.println("JDBC Driver: " + metadata.getDriverName());
        System.out.println("Driver Version: " + metadata.getDriverVersion());
        System.out.println("\n");
    }


    /**
     * Prints in the console the columns metadata, based in the Arraylist of
     * tables passed as parameter.
     *
     * @param tables
     * @throws SQLException
     */
    public static void getColumnsMetadata(Map<String, String> tables)
            throws SQLException {
        ResultSet rs = null;
        String result = new String();
        SystemManager systemManager = SystemManager.getInstance();
        // Print the columns properties of the actual table
        for (String actualTable : tables.keySet()) {
            rs = metadata.getColumns(null, null, actualTable, null);
            result += tables.get(actualTable) + ' ';
            result += actualTable.toUpperCase() + '\n';
            System.out.println(actualTable.toUpperCase());
            
            while (rs.next()) {
                result += rs.getString("COLUMN_NAME") + " " + rs.getString("TYPE_NAME") + " " + rs.getString("COLUMN_SIZE") + '\n';
                System.out.println(rs.getString("COLUMN_NAME") + " " + rs.getString("TYPE_NAME") + " " + rs.getString("COLUMN_SIZE"));
            }
            result += '\n' + "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n";
           
            System.out.println("\n");
        }
        systemManager.addTextToTextArea(result);

    }

    /**
     *
     * @param args
     */
    public static void getMetadata() {
        try {
            printGeneralMetadata();
            // Print all the tables of the database scheme, with their names and
            // structure
            getColumnsMetadata(getOwnerTables("STUDENT"));
        } catch (SQLException e) {
            System.err
                    .println("There was an error retrieving the metadata properties: "
                            + e.getMessage());
        }
    }

    private static Map<String, String> getOwnerTables(String owner) {

        Statement stmt = null;
        String query = "SELECT object_name, object_type FROM all_objects where owner = '" + owner + "' and object_type IN('TABLE', 'VIEW')";
        Map tables = new HashMap(); 
        String tableName = new String();
        String type = new String();
        
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                type = rs.getString("OBJECT_TYPE");
                tableName = rs.getString("OBJECT_NAME");
                tables.put(tableName, type);
                System.out.println(tableName + '\n');
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ex) {
                    Logger.getLogger(Metadata.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

        return tables;
    }
    
    public static void getObjectsInfo(String owner) {

        Statement stmt = null;
        String query = "SELECT object_name, object_type FROM all_objects where owner = '" + owner + "' and object_type IN('TRIGGER', 'PROCEDURE', 'FUNCTION')";
        String result = new String();
        
        String name = new String();
        String type = new String();
        
        try {
            stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                type = rs.getString("OBJECT_TYPE");
                result += type + '\n';   
                name = rs.getString("OBJECT_NAME");
                result += name + ' ';
                result += '\n' + "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n";       
            }
            
            SystemManager systemManager = SystemManager.getInstance();
            systemManager.addTextToTextArea(result);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException ex) {
                    Logger.getLogger(Metadata.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }
}
