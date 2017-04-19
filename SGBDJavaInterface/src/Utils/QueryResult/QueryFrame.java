/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils.QueryResult;

import System.SystemManager;
import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.EventQueue;
import java.sql.SQLException;
import java.util.StringTokenizer;
import javax.swing.JDesktopPane;
import javax.swing.JInternalFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;

/**
 *
 * @author Mihaela
 */
public class QueryFrame {

    ResultSetTableModelFactory factory;   // A factory to obtain our table data
    JTextField queryField;                     // A field to enter a queryField in
    JTable table;                         // The table for displaying data

    /**
     * This constructor method creates a simple GUI and hooks up an event
     * listener that updates the table when the user enters a new queryField.
     *
     */
    public QueryFrame(ResultSetTableModelFactory f) {
        // Remember the factory object that was passed to us
        this.factory = f;

        // Create the Swing components we'll be using
        //query = new JTextField();     // Lets the user enter a queryField
        table = new JTable();         // Displays the table

        // Place the components within this window
        SystemManager systemManager = SystemManager.getInstance();
        JDesktopPane desktopPane = systemManager.getDesktopPane();
        JScrollPane scrollPane = new JScrollPane(table);
        JInternalFrame frame = new JInternalFrame();

        //Container contentPane = systemManager.getMainFrame().getContentPane();
        frame.add(table);
        JScrollPane scroll = new JScrollPane(table);
        frame.getContentPane().add(scroll, BorderLayout.CENTER);
        frame.setTitle(systemManager.getQuery());
        frame.setResizable(true);
        frame.setClosable(true);
        frame.setMaximizable(true);
        frame.setIconifiable(true);
        frame.setSize(650, 400);
        frame.pack();
        frame.setVisible(true);

        desktopPane.add(frame);
        //contentPane.add(queryField, BorderLayout.NORTH);
        //contentPane.add(scrollPane, BorderLayout.CENTER);

        // Now hook up the JTextField so that when the user types a queryField
        // and hits ENTER, the queryField results get displayed in the JTable
        String query = systemManager.getQuery();

        displayQueryResults(query);

    }

    /**
     * This method uses the supplied SQL queryField string, and the
     * ResultSetTableModelFactory object to create a TableModel that holds the
     * results of the database queryField. It passes that TableModel to the
     * JTable component for display.
     *
     */
    public void displayQueryResults(final String q) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    // This is the crux of it all.  Use the factory object
                    // to obtain a TableModel object for the queryField results
                    // and display that model in the JTable component.
                    table.setModel(factory.getResultSetTableModel(q));

                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        });
    }
}
