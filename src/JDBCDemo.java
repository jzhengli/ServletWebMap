import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;


public class JDBCDemo {

    public static void main(String[] args){
        Connection conn;
        Statement stmt;
        try{
            //Load JDBC Driver
            Class.forName("org.postgresql.Driver");

            //establish connection
            String url = "jdbc:postgresql://localhost:5433/disastermngt";
            conn = DriverManager.getConnection(url, "postgres", "pgadmin");

            //query the database
            String sql = "select d.report_id as report_id, r.report_type as report_type, d.resource_type as resource_type, " +
                    "p.first_name as first_name, r.disaster_type as disaster_type, r.timestamp as time_stamp, ST_AsText(r.geom) as geom " +
                    "from report as r " +
                    "join person as p on r.reportor_id = p.id " +
                    "join donation_report as d on r.id = d.report_id";
            stmt = conn.createStatement();
            ResultSet res = stmt.executeQuery(sql);

            //print the result
            if(res != null){
                while(res.next()){
                    System.out.println("report_id: " + res.getString("report_id"));
                    System.out.println("report_type: " + res.getString("report_type"));
                    System.out.println("resource_type: " + res.getString("resource_type"));
                    System.out.println("first_name: " + res.getString("first_name"));
                    System.out.println("disaster: " + res.getString("disaster_type"));
                    System.out.println("time_stamp: " + res.getString("time_stamp"));
                    System.out.println("geom: " + res.getString("geom"));
                }
            }

            //clean up
            stmt.close();
            conn.close();
        }
        catch (Exception e){
            e.printStackTrace();
        }
    }
}
