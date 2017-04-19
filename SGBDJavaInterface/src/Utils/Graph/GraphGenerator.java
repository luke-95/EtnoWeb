/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils.Graph;

import System.DBConnector;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import org.graphstream.graph.Graph;
import org.graphstream.graph.Node;
import org.graphstream.graph.implementations.SingleGraph;

/**
 *
 * @author Mihaela
 */
public class GraphGenerator {
    public GraphGenerator() {
        DBConnector dBConnector = DBConnector.getInstance();
        Connection con = dBConnector.getConnection();
        Graph graph = new SingleGraph("DatabaseGraph");
        graph.setStrict(false);
        graph.setAutoCreate(true);
        graph.display();
        try {

            Statement stmt = con.createStatement();
            ResultSet tables = stmt.executeQuery("SELECT OBJECT_NAME FROM ALL_OBJECTS WHERE OBJECT_TYPE='TABLE' AND OWNER=USER");
            while (tables.next()) {
                String tableName = tables.getString("OBJECT_NAME");
                String query = "select table_name from all_constraints where constraint_type='R' and r_constraint_name in (select constraint_name from all_constraints where constraint_type in ('P','U') and table_name='" + tableName + "')";
                Statement stmt1 = con.createStatement();
                ResultSet anotherTables = stmt1.executeQuery(query);
                while (anotherTables.next()) {
                    String anotherTable = anotherTables.getString("table_name");
                    System.out.println(tableName+" "+anotherTable);
                    graph.addNode(tableName);
                    graph.addNode(anotherTable);
                    graph.addEdge(anotherTable + "_" + tables.getString("OBJECT_NAME"), anotherTable, tables.getString("OBJECT_NAME"), true);
                    Node ab = graph.getNode(tableName);
                    ab.setAttribute("ui.label", tableName);
                    ab = graph.getNode(anotherTable);
                    ab.setAttribute("ui.label", anotherTable);
                }
                anotherTables.close();
            }
            
            graph.addAttribute("ui.quality");
            graph.addAttribute("ui.antialias");
            graph.addAttribute("ui.stylesheet", "edge { fill-color: red; }");
            tables.close();
            stmt.close();
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
