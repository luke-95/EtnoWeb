/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package System;

import GUI.MainFrame;
import GUI.CheckPriceFrame;
import System.DBQueryParser.QueryTableModel;
import javax.swing.JDesktopPane;
import javax.swing.JFrame;
import javax.swing.JTextArea;

/**
 *
 * @author Mihaela
 */
public class SystemManager {
    private static SystemManager instance = null;
       private MainFrame mainFrame;
       private CheckPriceFrame checkPriceFrame;

    private SystemManager() {
        mainFrame = new MainFrame();
        checkPriceFrame = new CheckPriceFrame();
    }
    
    public static SystemManager getInstance() {
        if (instance == null) {
            instance = new SystemManager();
        }

        return instance;
    }
     
    public JFrame getMainFrame(){
        return mainFrame;
    }
    
    public JFrame getCheckPriceFrame(){
        return checkPriceFrame;
    }
    
    public String getQuery(){
        return mainFrame.getQuery();
    }
    
    public JDesktopPane getDesktopPane(){
        return mainFrame.getDesktopPane();
    }
    
    public JTextArea getTextArea(){
        return mainFrame.getTextArea();
    }
    
    public void addTextToTextArea(String text){
        mainFrame.addTextToTextArea(text);
    }
    
    public void run(){
         DBQueryParser queryParser = new DBQueryParser();
         
         //QueryTableModel qtm = new QueryTableModel();
    }
}
