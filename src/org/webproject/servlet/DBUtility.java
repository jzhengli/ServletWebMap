package org.webproject.servlet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtility {
    private static final String Driver = "org.postgresql.Driver";
    private static final String ConnUrl = "jdbc:postgresql://localhost:5433/disastermngt";
    private static final String Username = "postgres";
    private static final String Password = "pgadmin";

    public DBUtility(){

    }

    //create a connection to the database
    private Connection connectDB(){
        Connection conn = null;

        try{
            Class.forName(Driver);
            conn = DriverManager.getConnection(ConnUrl, Username, Password);
            return conn;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }

    //execute a sql query and return a ResultSet
    public ResultSet queryDB(String sql) {
        Connection conn = connectDB();
        ResultSet res = null;
        try {
            if(conn != null){
                Statement stmt = conn.createStatement();
                res = stmt.executeQuery(sql);
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    //execute a sql query to modify the database
    public  void modifyDB(String sql) {
        Connection conn = connectDB();
        try{
            if (conn != null) {
                Statement stmt = conn.createStatement();
                stmt.execute(sql);
                stmt.close();
                conn.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        //test methods created above
        DBUtility util = new DBUtility();

//        //1.create a user
//        util.modifyDB("insert into person (first_name, last_name) values ('test_user_1_fN', 'test_user_1_lN')");
//
//        //2.query the database
//        ResultSet res = util.queryDB("select * from person where first_name = 'test_user_1_fN'");
//        try {
//            while (res.next()) {
//                System.out.println(res.getString("last_name"));
//            }
//        } catch (SQLException e){
//            e.printStackTrace();
//        }

        //3 - question 6 - query report table
        ResultSet res2 = util.queryDB("select * from report");
        try {
            while (res2.next()) {
                System.out.println(res2.getString("report_type"));
            }
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
}
