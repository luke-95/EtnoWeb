/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package System;

import GUI.WelcomeFrame;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Mihaela
 */
public class DBConnector {

    private static DBConnector instance = null;
    private static String driver;
    private static String url;
    private static String user;
    private static String password;
    Connection con;
    //private static WelcomeFrame welcomeFrame = new WelcomeFrame();

    public static DBConnector getInstance() {
        if (instance == null) {
            instance = new DBConnector();
        }

        return instance;
    }

    public Connection getConnection(){
        return con;
    }
    
    private DBConnector() {

        this.driver = new String();
        this.url = new String();
        this.user = new String();
        this.password = new String();
    }

    public void setDriver(String drv) {
        driver = drv;
    }

    public void setURL(String u) {
        url = u;
    }

    public void setUser(String urs) {
        user = urs;
    }

    public void setPassword(String pass) {
        password = pass;
    }

    private static void getUserConnectionDetails() {
        /*welcomeFrame = new WelcomeFrame();
        java.awt.EventQueue.invokeLater(new Runnable() {
          public void run() {
            new WelcomeFrame().setVisible(true);
          }
       });*/
 /*driver = welcomeFrame.getDriver();
        url = welcomeFrame.getURL();
        user = welcomeFrame.getUser();
        password = welcomeFrame.getPassword();*/
    }

    public void establishConnection() {
        try {
//step1 load the driver class  

            System.out.println("Driver: " + driver + "\nURL: " + url + "\nUser: " + user + "\nPassword: " + password);
            Class.forName(driver);

//step2 create  the connection object  
            con = DriverManager.getConnection(url, user, password);

            //step3 create the statement object  
            /*Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from studenti");
            while (rs.next()) {
                System.out.println(rs.getInt(1) + "  " + rs.getString(2) + "  " + rs.getString(3));
            }*/
            //runQuery(url);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Failed to connect to DB: ");
            e.printStackTrace();
        }

    }

    
    public void closeConnection(){
        try {
            //step5 close the connection object
            con.close();
        } catch (SQLException ex) {
            Logger.getLogger(DBConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
