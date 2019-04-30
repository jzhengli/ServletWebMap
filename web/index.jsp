<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Web Project</title>

    <!-- custom styles -->
    <link rel="stylesheet" href="css/style.css">

    <!-- jQuery -->
    <script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
    <script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>

    <!-- Google Map js lib -->
    <script src="https://maps.googleapis.com/maps/api/js?key={Google Maps API key here}&libraries=places,visualization"></script>


</head>
<body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
        <a class="navbar-brand">Disaster Management Portal</a>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <div class="sidebar col-xs-3">
                <!-- Tab Navis -->
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#create_report" data-toggle="tab">Create Report</a></li>
                    <li><a href="#query_report" data-toggle="tab">Query</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <!-- Create Report Tab Panel -->
                    <div class="tab-pane active" id="create_report">
                        <form id="create_report_form">
                            <div><label>First Name:&nbsp</label><input placeholder="Your first name" name="fN"></div>
                            <div><label>Last Name:&nbsp</label><input placeholder="Your last name" name="lN"></div>
                            <div>
                                <label><input type="radio" name="gender" value="t">&nbspMale</label>
                                <label><input type="radio" name="gender" value="f">&nbspFemale</label>
                            </div>
                            <div><label>Age:&nbsp</label><input placeholder="Your age" name="age"></div>
                            <div>
                                <label>Blood Type:</label>
                                <select name="blood_type">
                                    <option value="A">A</option>
                                    <option value="B">B</option>
                                    <option value="O">O</option>
                                    <option value="AB">AB</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div><label>Tel:&nbsp</label><input placeholder="Your telephone number" name="tel"></div>
                            <div><label>Email:&nbsp</label><input placeholder="Your email address" name="email"></div>
                            <div><label>Contact's First Name:&nbsp</label><input placeholder="Contact's first name" name="contact_fN"></div>
                            <div><label>Contact's Last Name:&nbsp</label><input placeholder="Contact's last name" name="contact_lN"></div>
                            <div><label>Contact's Tel:&nbsp</label><input placeholder="Contact's telephone number" name="contact_tel"></div>
                            <div><label>Contact's Email:&nbsp</label><input placeholder="Contact's email address" name="contact_email"></div>
                            <div>
                                <label>Report Type:</label>
                                <select onchange="onSelectReportType(this)" name="report_type">
                                    <option value="">Choose the report type</option>
                                    <option value="donation">Donation</option>
                                    <option value="request">Request</option>
                                    <option value="damage">Damage</option>
                                </select>
                            </div>
                            <div class="additional_msg_div" style="visibility: hidden">
                                <label class="additional_msg"></label>
                                <select class="additional_msg_select" name="additional_message"></select>
                            </div>
                            <div>
                                <label>Disaster Type:</label>
                                <select name="disaster_type">
                                    <option value="">Choose the disaster type</option>
                                    <option value="flood">flood</option>
                                    <option value="wildfire">wildfire</option>
                                    <option value="earthquake">earthquake</option>
                                    <option value="tornado">tornado</option>
                                    <option value="hurricane">hurricane</option>
                                    <option value="other">other</option>
                                </select>
                            </div>
                            <div><label>Address:</label><input id="autocomplete" placeholder="Address"></div>
                            <div><label>Comment:&nbsp</label><input placeholder="Additional message" name="message"></div>
                            <button type="submit" class="btn btn-default" id="report_submit_btn">
                                <span class="glyphicon glyphicon-star"></span> Submit
                            </button>
                        </form>
                    </div>

                    <!-- Query Report Tab Panel -->
                    <div class="tab-pane" id="query_report">
                        <form id="query_report_form">
                            <div>
                                <label>Report Type:</label>
                                <select onchange="onSelectReportType(this)" name="report_type">
                                    <option value="">Choose the report type</option>
                                    <option value="donation">Donation</option>
                                    <option value="request">Request</option>
                                    <option value="damage">Damage Report</option>
                                </select>
                            </div>
                            <div class="additional_msg_div" style="visibility: hidden">
                                <label class="additional_msg"></label>
                                <select class="additional_msg_select" name="additional_message"></select>
                            </div>
                            <div>
                                <label>Disaster Type:</label>
                                <select name="disaster_type">
                                    <option value="">Choose the disaster type</option>
                                    <option value="flood">flood</option>
                                    <option value="wildfire">wildfire</option>
                                    <option value="earthquake">earthquake</option>
                                    <option value="tornado">tornado</option>
                                    <option value="hurricane">hurricane</option>
                                    <option value="other">other</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-default">
                                <span class="glyphicon glyphicon-star"></span> Submit the query
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div id="map-canvas" class="col-xs-9"></div>

        </div>
    </div>

    <script src="js/loadForm.js"></script>
    <script src="js/loadMap.js"></script>


    <script type="text/javascript">
    /* servlet test
    window.onload = initialize();
    function initialize() {
        $.ajax({
            url: 'HttpServlet',
            type: 'POST',
            success: function(data){
                $.each(data, function(i, name) {
                    alert("key: " + i + ", value: " + name);
                });
            },
            error: function(xhr, status, error) {
                alert("An AJAX error occurred: " + status + "\nError: " + error);
            }
        });
    }
    */
    window.onload = tests();
    function tests() {
      /*---- un-comment to call test functions below ----*/
      //test_report_submission();
      //test_query_report();

      //lab 3.2 test------------------------------------------------------
      //step 158: submit new report for Dannis Black
        // another_user_report();
      //step 153: query hurricane damage report
        //query_hurricane_report();
      //step 167: test submitting report using JSP
        //test_report_submission2();
      //step 169: question 10, test querying report using JSP
      //test_query_report2();
    }

    function test_report_submission() {
      $.ajax({
        url: 'HttpServlet',
        type: 'POST',
        data: { "tab_id": "0",
            "fN": "Jason",
            "lN": "Zhou",
            "gender": "t",
            "age": "30",
            "blood_type": "AB",
            "tel": "928-777-8856",
            "email": "jasonzhou@gmail.com",
            "contact_fN": "Bill",
            "contact_lN": "Huang",
            "contact_tel": "608-888-9876",
            "contact_email": "billh@gmail.com",
            "report_type": "request",
            "disaster_type": "wildfire",
            "longitude": "-87",
            "latitude": "33",
            "message": "request rescue!!!",
            "additional_message": "rescue/volunteer"},
        success: function(data){
          $.each(data, function(i, name) {
            alert("key: " + i + ", value: " + name);
          });
        },
        error: function(xhr, status, error) {
          alert("An AJAX error occurred: " + status + "\nError: " + error);
        }
      });
    }

    function test_query_report() {
      $.ajax({
        url: 'HttpServlet',
        type: 'POST',
        data: { "tab_id": "1",
            "disaster_type": "hurricane",
            "report_type": "donation",
            "additional_message": "food"},
        success: function(data){
          $.each(data, function(i, e) {
            alert(JSON.stringify(e));
          });
        },
        error: function(xhr, status, error) {
          alert("An AJAX error occurred: " + status + "\nError: " + error);
        }
      });
    }

    //function to create another user report
    function another_user_report(){
        $.ajax({
            url: 'HttpServlet',
            type: 'POST',
            data: { "tab_id": "0",
                "fN": "Dannis",
                "lN": "Black",
                "report_type": "damage",
                "disaster_type": "hurricane",
                "longitude": "26.89",
                "latitude": "35.12",
                "additional_message": "pollution"},
            success: function(data){
                $.each(data, function(i, name) {
                    alert("key: " + i + ", value: " + name);
                });
            },
            error: function(xhr, status, error) {
                alert("An AJAX error occurred: " + status + "\nError: " + error);
            }
        });
    }

    //function to query hurricane damage reports
    function query_hurricane_report(){
        $.ajax({
            url: 'HttpServlet',
            type: 'POST',
            data: { "tab_id": "1",
                "disaster_type": "hurricane",
                "report_type": "damage"},
            success: function(data){
                $.each(data, function(i, e) {
                    alert(JSON.stringify(e));
                });
            },
            error: function(xhr, status, error) {
                alert("An AJAX error occurred: " + status + "\nError: " + error);
            }
        });
    }

    //function to test creating report in runQuery.jsp
    function test_report_submission2() {
        $.ajax({
            url: 'runQuery.jsp',
            type: 'POST',
            data: { "tab_id": "0",
                "fN": "Mary",
                "lN": "Jones",
                "gender": "f",
                "age": "33",
                "blood_type": "B",
                "tel": "651-734-2863",
                "email": "mjones123@gmail.com",
                "contact_fN": "Eve",
                "contact_lN": "James",
                "contact_tel": "611-232-9654",
                "contact_email": "ejames21@hotmail.com",
                "report_type": "request",
                "disaster_type": "wildfire",
                "longitude": "-86",
                "latitude": "33.5",
                "message": "need rescue!",
                "additional_message": "rescue/volunteer"},
            success: function(data){
                $.each(data, function(i, name) {
                    alert("key: " + i + ", value: " + name);
                });
            },
            error: function(xhr, status, error) {
                alert("An AJAX error occurred: " + status + "\nError: " + error);
            }
        });
    }

    //function to test query report in runQuery.jsp
    function test_query_report2() {
        $.ajax({
            url: 'runQuery.jsp',
            type: 'POST',
            data: { "tab_id": "1",
                "disaster_type": "hurricane",
                "report_type": "donation",
                "additional_message": "food"},
            success: function(data){
                $.each(data, function(i, e) {
                    alert(JSON.stringify(e));
                });
            },
            error: function(xhr, status, error) {
                alert("An AJAX error occurred: " + status + "\nError: " + error);
            }
        });
    }

</script>
</body>
</html>
