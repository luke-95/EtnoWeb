/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Utils.Report;

import System.DBConnector;
import java.io.FileOutputStream;
import java.io.*;
import java.util.*;
import java.sql.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Mihaela
 */
public class ReportGenerator {

    public void generateReport(String query) {
        try {
            DBConnector dBConnector = DBConnector.getInstance();
            Connection conn = dBConnector.getConnection();
            Statement stmt = conn.createStatement();
            /* Define the SQL query */
            ResultSet query_set = stmt.executeQuery(query);
            /* Step-2: Initialize PDF documents - logical objects */
            Document my_pdf_report = new Document();
            PdfWriter.getInstance(my_pdf_report, new FileOutputStream("Report.pdf"));
            my_pdf_report.open();
            
            
            //create a cell object
            PdfPCell table_cell;
            table_cell = new PdfPCell(new Phrase(query));
            my_pdf_report.add(table_cell);
            my_pdf_report.addTitle(query);
            my_pdf_report.setMargins(0, 0, 0, 0);
         
            //get columns names
            java.util.List<String> columns = new ArrayList<>();
            int i = 1;
            try {
                while (query_set.getMetaData().getColumnName(i) != null) {
                    String name = query_set.getMetaData().getColumnName(i);
                    columns.add(name);
                    System.out.println(name);

                    i++;
                }
            } catch (SQLException ex) {

            }

            //we have four columns in our table
            PdfPTable my_report_table = new PdfPTable(columns.size());

            //populate table with header (columns names)
            for (int poz = 0; poz < columns.size(); poz++) {
                String value = columns.get(poz);
                table_cell = new PdfPCell(new Phrase(value));
                my_report_table.addCell(table_cell);
            }

            //populate  table with data
            while (query_set.next()) {
                for (int poz = 0; poz < columns.size(); poz++) {
                    String value = query_set.getString(columns.get(poz));
                    //String dept_id = query_set.getString("NUME");
                    table_cell = new PdfPCell(new Phrase(value));
                    my_report_table.addCell(table_cell);
                }

            }
            /* Attach report table to PDF */
            my_pdf_report.add(my_report_table);
            my_pdf_report.close();

            /* Close all DB related objects */
            query_set.close();
            stmt.close();
        } catch (SQLException ex) {
            Logger.getLogger(ReportGenerator.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DocumentException ex) {
            Logger.getLogger(ReportGenerator.class.getName()).log(Level.SEVERE, null, ex);
        } catch (FileNotFoundException ex) {
            Logger.getLogger(ReportGenerator.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
}
