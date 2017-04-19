/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package System;

//import QueryTableModel;
import java.awt.BorderLayout;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author Mihaela
 */
public class DBQueryParser {

    public DBQueryParser() {
        qtm = new QueryTableModel();
        JTable table = new JTable(qtm);
        JScrollPane scrollpane = new JScrollPane(table);
        //getContentPane().add(scrollpane, BorderLayout.CENTER);
    }

    Vector cache; // will hold String[] objects . . .
    int colCount;
    String[] headers;
    Connection db;
    Statement statement;
    String currentURL;

    JTextField hostField;
    JTextField queryField;
    QueryTableModel qtm;

    DBConnector dBConnector = DBConnector.getInstance();

    public void runQuery(String query) {
        Connection con = dBConnector.getConnection();
        query = "select * from studenti";
        System.out.println(query);
        int i = 0;
        try {
            //step3 create the statement object
            Statement stmt = con.createStatement();

            //step4 execute query
            ResultSet rs = stmt.executeQuery(query);
            while (rs.next()) {
                i++;
                System.out.println(rs.getInt(1) + "  " + rs.getString(2) + "  " + rs.getString(4));

            }
        } catch (SQLException ex) {
            Logger.getLogger(DBConnector.class
                    .getName()).log(Level.SEVERE, null, ex);

        }
    }

    class QueryTableModel extends AbstractTableModel {

        Vector cache; // will hold String[] objects . . .

        int colCount;

        String[] headers;

        Connection db;

        Statement statement;

        String currentURL;

        public QueryTableModel() {
            cache = new Vector();
            //new gsl.sql.driv.Driver();
        }

        public String getColumnName(int i) {
            return headers[i];
        }

        public int getColumnCount() {
            return colCount;
        }

        public int getRowCount() {
            return cache.size();
        }

        public Object getValueAt(int row, int col) {
            return ((String[]) cache.elementAt(row))[col];
        }

        // All the real work happens here; in a real application,
        // we'd probably perform the query in a separate thread.
        public void setQuery(String q) {
            System.out.println(q);
            cache = new Vector();
            try {
                // Execute the query and store the result set and its metadata
                ResultSet rs = statement.executeQuery(q);
                ResultSetMetaData meta = rs.getMetaData();
                colCount = meta.getColumnCount();

                // Now we must rebuild the headers array with the new column names
                headers = new String[colCount];
                for (int h = 1; h <= colCount; h++) {
                    headers[h - 1] = meta.getColumnName(h);
                }

                // and file the cache with the records from our query. This would
                // not be
                // practical if we were expecting a few million records in response
                // to our
                // query, but we aren't, so we can do this.
                while (rs.next()) {
                    String[] record = new String[colCount];
                    for (int i = 0; i < colCount; i++) {
                        record[i] = rs.getString(i + 1);
                    }
                    cache.addElement(record);
                }
                fireTableChanged(null); // notify everyone that we have a new table.
            } catch (Exception e) {
                cache = new Vector(); // blank it out and keep going.
                e.printStackTrace();
            }
        }

    }
}
