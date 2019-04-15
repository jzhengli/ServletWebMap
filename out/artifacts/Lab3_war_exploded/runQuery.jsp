<%@ page import="java.io.*"%>
<%@ page import="org.json.*"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="org.webproject.servlet.DBUtility"%>
<%@ page import="java.util.HashMap" %>

<html>
<body>

<%
    PrintWriter output = response.getWriter();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String tab_id = request.getParameter("tab_id");

    // create a report
    if (tab_id.equals("0")) {
        System.out.println("A report is submitted!");
        try {
            DBUtility dbUtil = new DBUtility();
            String sql;

            //1.create emergency contact
            int contact_id = 0;
            String contact_fN = request.getParameter("contact_fN");
            String contact_lN = request.getParameter("contact_lN");
            String contact_tel = request.getParameter("contact_tel");
            String contact_email = request.getParameter("contact_email");
            if(contact_fN != null) {contact_fN = "'" + contact_fN + "'";}
            if(contact_lN != null) {contact_lN = "'" + contact_lN + "'";}
            if(contact_tel != null) {contact_tel = "'" + contact_tel + "'";}
            if(contact_email != null) {contact_email = "'" + contact_email + "'";}
            if(contact_fN != null && contact_lN != null) {
                //create the contact
                sql = "insert into person (first_name, last_name, telephone, email) " +
                        "values (" + contact_fN + "," + contact_lN + "," + contact_tel + "," + contact_email + ")";
                dbUtil.modifyDB(sql);

                //record the contact id
                ResultSet res_1 = dbUtil.queryDB("select last_value from person_id_seq");
                res_1.next();
                contact_id = res_1.getInt(1);

                System.out.println("Success! Contact created.");
            }

            // 2. create user
            int user_id = 0;
            String fN = request.getParameter("fN");
            String lN = request.getParameter("lN");
            String gender = request.getParameter("gender");
            String age = request.getParameter("age");
            String blood_type = request.getParameter("blood_type");
            String tel = request.getParameter("tel");
            String email = request.getParameter("email");
            if (fN != null) {fN = "'" + fN + "'";}
            if (lN != null) {lN = "'" + lN + "'";}
            if (gender != null) {gender = "'" + gender + "'";}
            if (age != null) {age = "'" + age + "'";}
            if (blood_type != null) {blood_type = "'" + blood_type + "'";}
            if (tel != null) {tel = "'" + tel + "'";}
            if (email != null) {email = "'" + email + "'";}

            sql = "insert into person (first_name, last_name, gender, age, blood_type, telephone, email, emergency_contact_id) " +
                    "values (" + fN + "," + lN + "," + gender + "," + age + "," + blood_type + "," + tel + "," + email;
            if (contact_id > 0) {
                sql += "," + contact_id + ")";
            } else {
                sql += ",null)";
            }
            dbUtil.modifyDB(sql);

            //record user_id
            ResultSet res_2 = dbUtil.queryDB("select last_value from person_id_seq");
            res_2.next();
            user_id = res_2.getInt(1);

            System.out.println("Success! User created.");

            // 3. create report
            int report_id = 0;
            String report_type = request.getParameter("report_type");
            String disaster_type = request.getParameter("disaster_type");
            String lon = request.getParameter("longitude");
            String lat = request.getParameter("latitude");
            String message = request.getParameter("message");
            String add_msg = request.getParameter("additional_message");
            if (report_type != null) {report_type = "'" + report_type + "'";}
            if (disaster_type != null) {disaster_type = "'" + disaster_type + "'";}
            if (message != null) {message = "'" + message + "'";}
            if (add_msg != null) {add_msg = "'" + add_msg + "'";}

            sql = "insert into report (reportor_id, report_type, disaster_type, geom, message) " +
                    "values (" + user_id + "," + report_type + "," + disaster_type + ", ST_GeomFromText('POINT(" + lon + " " + lat + ")', 4326)" +
                    "," + message + ")";
            dbUtil.modifyDB(sql);

            //record report_id
            ResultSet res_3 = dbUtil.queryDB("select last_value from report_id_seq");
            res_3.next();
            report_id = res_3.getInt(1);

            System.out.println("Success! Report created.");

            // 4. create specific report
            if (report_type.equals("'donation'")) {
                sql = "insert into donation_report (report_id, resource_type) " +
                        "values ('" + report_id + "'," + add_msg + ")";
                System.out.println("Success! Donation report created.");
            } else if (report_type.equals("'request'")) {
                sql = "insert into request_report (report_id, resource_type) " +
                        "values ('" + report_id + "'," + add_msg + ")";
                System.out.println("Success! Request report created.");
            } else if (report_type.equals("'damage'")) {
                sql = "insert into damage_report (report_id, damage_type) " +
                        "values ('" + report_id + "'," + add_msg + ")";
                System.out.println("Success! Damage report created.");
            } else {
                return;
            }
            dbUtil.modifyDB(sql);

            // response that the report submission is successful
            JSONObject data = new JSONObject();
            try{
                data.put("status", "success");
            } catch (JSONException e){
                e.printStackTrace();
            }
            output.write(data.toString());

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // query report
    else if (tab_id.equals("1")) {
        try {
            DBUtility dbUtil = new DBUtility();
            JSONArray list = new JSONArray();

            String disaster_type = request.getParameter("disaster_type");
            String report_type = request.getParameter("report_type");
            String add_message = request.getParameter("additional_message");

            // request report
            if (report_type == null || report_type.equalsIgnoreCase("request")) {
                String sql = "select report.id, report_type, resource_type, " +
                        "disaster_type, first_name, last_name, timestamp, ST_X(geom) as " +
                        "longitude, ST_Y(geom) as latitude, message from report, person, " +
                        "request_report where reportor_id = person.id and report.id = " +
                        "report_id";

                if (disaster_type != null) {
                    sql += " and disaster_type = '" + disaster_type + "'";
                }
                if (add_message != null) {
                    if (report_type.equalsIgnoreCase("damage")) {
                        sql += " and damage_type = '" + add_message + "'";
                    } else {
                        sql += " and resource_type = '" + add_message + "'";
                    }
                }

                ResultSet res = dbUtil.queryDB(sql);

                while (res.next()) {
                    // add to response
                    HashMap<String, String> m = new HashMap<String, String>();
                    m.put("report_id", res.getString("id"));
                    m.put("report_type", res.getString("report_type"));
                    if (report_type.equalsIgnoreCase("donation") ||
                            report_type.equalsIgnoreCase("request")) {
                        m.put("resource_type", res.getString("resource_type"));
                    } else if (report_type.equalsIgnoreCase("damage")) {
                        m.put("damage_type", res.getString("damage_type"));
                    }
                    m.put("disaster", res.getString("disaster_type"));
                    m.put("first_name", res.getString("first_name"));
                    m.put("last_name", res.getString("last_name"));
                    m.put("timestamp", res.getString("timestamp"));
                    m.put("longitude", res.getString("longitude"));
                    m.put("latitude", res.getString("latitude"));
                    m.put("message", res.getString("message"));
                    list.put(m);
                }
            }

            // donation report
            if (report_type == null || report_type.equalsIgnoreCase("donation")) {
                String sql = "select report.id, report_type, resource_type, " +
                        "disaster_type, first_name, last_name, timestamp, ST_X(geom) as " +
                        "longitude, ST_Y(geom) as latitude, message from report, person, " +
                        "donation_report where reportor_id = person.id and report.id = " +
                        "report_id";

                if (disaster_type != null) {
                    sql += " and disaster_type = '" + disaster_type + "'";
                }
                if (add_message != null) {
                    if (report_type.equalsIgnoreCase("damage")) {
                        sql += " and damage_type = '" + add_message + "'";
                    } else {
                        sql += " and resource_type = '" + add_message + "'";
                    }
                }

                ResultSet res = dbUtil.queryDB(sql);

                while (res.next()) {
                    // add to response
                    HashMap<String, String> m = new HashMap<String, String>();
                    m.put("report_id", res.getString("id"));
                    m.put("report_type", res.getString("report_type"));
                    if (report_type.equalsIgnoreCase("donation") ||
                            report_type.equalsIgnoreCase("request")) {
                        m.put("resource_type", res.getString("resource_type"));
                    } else if (report_type.equalsIgnoreCase("damage")) {
                        m.put("damage_type", res.getString("damage_type"));
                    }
                    m.put("disaster", res.getString("disaster_type"));
                    m.put("first_name", res.getString("first_name"));
                    m.put("last_name", res.getString("last_name"));
                    m.put("timestamp", res.getString("timestamp"));
                    m.put("longitude", res.getString("longitude"));
                    m.put("latitude", res.getString("latitude"));
                    m.put("message", res.getString("message"));
                    list.put(m);
                }
            }

            // damage report
            if (report_type == null || report_type.equalsIgnoreCase("damage")) {
                String sql = "select report.id, report_type, damage_type, " +
                        "disaster_type, first_name, last_name, timestamp, ST_X(geom) as " +
                        "longitude, ST_Y(geom) as latitude, message from report, person, " +
                        "damage_report where reportor_id = person.id and report.id = " +
                        "report_id";

                if (disaster_type != null) {
                    sql += " and disaster_type = '" + disaster_type + "'";
                }
                if (add_message != null) {
                    if (report_type.equalsIgnoreCase("damage")) {
                        sql += " and damage_type = '" + add_message + "'";
                    } else {
                        sql += " and resource_type = '" + add_message + "'";
                    }
                }

                ResultSet res = dbUtil.queryDB(sql);

                while (res.next()) {
                    // add to response
                    HashMap<String, String> m = new HashMap<String, String>();
                    m.put("report_id", res.getString("id"));
                    m.put("report_type", res.getString("report_type"));
                    if (report_type.equalsIgnoreCase("donation") ||
                            report_type.equalsIgnoreCase("request")) {
                        m.put("resource_type", res.getString("resource_type"));
                    } else if (report_type.equalsIgnoreCase("damage")) {
                        m.put("damage_type", res.getString("damage_type"));
                    }
                    m.put("disaster", res.getString("disaster_type"));
                    m.put("first_name", res.getString("first_name"));
                    m.put("last_name", res.getString("last_name"));
                    m.put("timestamp", res.getString("timestamp"));
                    m.put("longitude", res.getString("longitude"));
                    m.put("latitude", res.getString("latitude"));
                    m.put("message", res.getString("message"));
                    list.put(m);
                }
            }

            output.write(list.toString());
        } catch (SQLException e){
            e.printStackTrace();
        }
    }
    output.close();
%>
</body>
</html>