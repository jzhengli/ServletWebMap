function onSelectReportType(ele){
    var form = $(ele).parent().parent();
    var label = $(form).find(".additional_msg");
    var select = $(form).find(".additional_msg_select");

    switch (ele.value) {
        case "donation":
        case "request":
            label.text("Resource Type:");
            select.find('option').remove();
            select.append($("<option></option>")
                .attr("value", "")
                .text("Choose the resource type"));
            selectValues = ['water', 'food', 'money', 'medicine', 'cloth', 'rescue/volunteer', 'other'];
            $.each(selectValues, function (index, value) {
                select.append($("<option></option>")
                    .attr("value", value)
                    .text(value));
            });
            break;
        case "damage":
            label.text("Damage Type:");
            select.find('option').remove();
            select.append($("<option></option>")
                .attr("value", "")
                .text("Choose the damage type"));
            selectValues = ['pollution', 'building damage', 'road damage', 'casualty', 'other'];
            $.each(selectValues, function (index, value) {
                select.append($("<option></option>")
                    .attr("value", value)
                    .text(value));
            });
            break;
        default:
            $(form).find(".additional_msg_div").css("visibility", "hidden");
            return;
    }
    $(form).find(".additional_msg_div").css("visibility", "visible");
}

function queryReport(event) {
    event.preventDefault(); // stop form from submitting normally

    var a = $("#query_report_form").serializeArray();
    a.push({ name: "tab_id", value: "1" });
    a = a.filter(function(item){return item.value != '';});
    $.ajax({
        url: 'HttpServlet',
        type: 'POST',
        data: a,
        success: function(reports) {
            mapInitialization(reports);
        },
        error: function(xhr, status, error) {
            alert("Status: " + status + "\nError: " + error);
        }
    });
}

$("#query_report_form").on("submit",queryReport);

//--- Question 4 - complete create report tab to submit a report ------------------
function createReport(event) {
    event.preventDefault();

    var a = $("#create_report_form").serializeArray();
    a.push({ name: "tab_id", value: "0" });
    //step 2 - add location to request info
    a.push({ name: "longitude", value: place.geometry.location.lng()});
    a.push({ name: "latitude", value: place.geometry.location.lat()});

    a = a.filter(function(item){return item.value != '';});
    //step 1 - ajax request to POST data
    $.ajax({
        url: 'HttpServlet',
        type: 'POST',
        data: a,
        success: function (report) {
            //step 3 - alert box after successfully submitted report
            alert("The report is successfully submitted!");

            //step 5 - show marker for the new report
            $.ajax({
                url: 'HttpServlet',
                type: 'POST',
                data: { "tab_id": "1"},
                success: function(reports) {
                    mapInitialization(reports);
                    //*step 6 - re-center map to the new report marker
                    onPlaceChanged();
                },
                error: function(xhr, status, error) {
                    alert("An AJAX error occurred: " + status + "\nError: " + error);
                }
            });

            //step 4 - reset form and hide additional message div
            document.getElementById("create_report_form").reset();
            $("#create_report_form").find(".additional_msg_div").css("visibility", "hidden");

        },
        error: function (xhr, status, error) {
            alert("An AJAX error occurred: " + status + "\nError: " + error);
        }

    });
}

$("#create_report_form").on("submit",createReport);
//---- End of Question 4 ----------------------------------------------------------