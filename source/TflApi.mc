import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.WatchUi;
import Toybox.Time;

const BASE_URL = "https://api.tfl.gov.uk/";

// The TfL API assigns numerical codes to each status severity, and it seems like you could *mostly* get by just
// treating lower numbers as being more severe, but that may not necessarily work in all cases. So below is a list of
// most severity descriptions observed at https://api.tfl.gov.uk/Line/Meta/Severity (excluding some that seem clearly
// only intended for use with stations, rather than lines), ordered roughly in the order of severity.
const SEVERITIES = {
	"Closed" => 0,
    "Service Closed" => 0,
	"No Service" => 1,
	"Not Running" => 2,
	"Planned Closure" => 3,
	"Suspended" => 4,
	"Part Closure" => 5,
	"Part Closed" => 6,
	"Part Suspended" => 7,
	"Severe Delays" => 8,
	// Special Service is used differently on different lines and can mean anything from minor delays to suspended.
	"Special Service" => 9,
	"Reduced Service" => 10,
	"Bus Service" => 11,
	"Change of frequency" => 12,
	"Diverted" => 13,
	"Issues Reported" => 14,
	"Minor Delays" => 16,
	"Information" => 16,
	"No Issues" => 17,
	"Good Service" => 18,
};

// A route (or part thereof) that is affected by a disruption. 
class AffectedRoute {
    public var originName as String;
    public var destinationName as String;
    public var direction as String;
    public var isEntireRouteSection as Boolean;

    function initialize(dict as Dictionary) {
        originName = dict["originationName"];
        destinationName = dict["destinationName"];
        direction = dict["direction"];
        isEntireRouteSection = dict["isEntireRouteSection"];
    }
}

// A period during which a particular status is valid.
class ValidityPeriod {
    public var fromDateTime as Moment;
    public var toDateTime as Moment;
    public var isNow as Boolean;

    function initialize(dict as Dictionary) {
        fromDateTime = parseDateTime(dict["fromDate"]);
        toDateTime = parseDateTime(dict["toDate"]);
        isNow = dict["isNow"];
    }
}

// A single line status (of which a line may have several at any given time).
class LineStatus {
    public var apiSeverity as Number;  // Status severity according to the API
    public var internalSeverity as Number;  // Status severity according to `SEVERITIES` lookup
    public var description as String;
    public var reason as String?;
    public var validityPeriods as Array<ValidityPeriod>;
    public var affectedRoutes as Array<AffectedRoute>;

    function initialize(dict as Dictionary) {
        apiSeverity = dict["statusSeverity"];
        internalSeverity = SEVERITIES[dict["statusSeverityDescription"]];
        description = dict["statusSeverityDescription"];
        reason = dict["reason"];
        var vpArr = dict["validityPeriods"] as Array<Dictionary>;
        validityPeriods = [];
        for (var i = 0; i < vpArr.size(); i++) {
            validityPeriods.add(new ValidityPeriod(vpArr[i]));
        }
        affectedRoutes = [];
        if (dict["disruption"] != null) {
            var arArr = (dict["disruption"] as Dictionary)["affectedRoutes"] as Array<Dictionary>;
            for (var i = 0; i < arArr.size(); i++) {
                affectedRoutes.add(new AffectedRoute(arArr[i]));
            }
        }
    }
}

class LineStatusData {
    public var id as String;
    public var name as String;
    public var modeName as String;
    public var statuses as Array<LineStatus>;

    function initialize(dict as Dictionary) {
        id = dict["id"];
        name = dict["name"];
        modeName = dict["modeName"];
        statuses = [];
        var lsArr = dict["lineStatuses"] as Array<Dictionary>;
        for (var i = 0; i < lsArr.size(); i++) {
            statuses.add(new LineStatus(lsArr[i]));
        }
    }

    function mostSevereStatus() as LineStatus? {
        var mostSevere = null;
        for (var i = 0; i < statuses.size(); i++) {
            var s = statuses[i];
            System.println("s: " + s);
            System.println("ms: " + mostSevere);
            System.println("s.sev: " + s.internalSeverity);
            System.println("s.desc: " + s.description);
            //System.println("ms.sev: " + mostSevere.internalSeverity);
            if (mostSevere == null || s.internalSeverity < mostSevere.internalSeverity) {
                mostSevere = s;
            }
        }
        return mostSevere;
    }
}

function lineStatusDataArray(data as Array<Dictionary>) as Array<LineStatusData> {
    var arr = [];
    for (var i = 0; i < data.size(); i++) {
        arr.add(new LineStatusData(data[i]));
    }
    return arr;
}

class TflApi {

    public var statusMessage = "";
    public var errorMessage = "";
    var lineStatuses as Array<LineStatusData> = [];

    // Get the status of the given lines.
    function getLineStatuses(lines as Array<String>, callback as Method) {
        var ids = joinArray(lines, ',');
        var url = BASE_URL + "/Line/" + ids + "/Status";
        var params = {};
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "User-Agent" => "LondonPublicTransport App for Garmin v0.0.1"
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(url, params, options, callback);

        statusMessage = "Requesting...";
        WatchUi.requestUpdate();
    }

    // Get the status of all lines for the given modes.
    function getModeLineStatuses(modes as Array<String>, callback as Method) {
        var modeIds = joinArray(modes, ',');
        var url = BASE_URL + "/Line/Mode/" + modeIds + "/Status";
        var params = {};
                var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "User-Agent" => "LondonPublicTransport App for Garmin v0.0.1"
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        Communications.makeWebRequest(url, params, options, callback);

        statusMessage = "Requesting...";
        WatchUi.requestUpdate();
    }

}