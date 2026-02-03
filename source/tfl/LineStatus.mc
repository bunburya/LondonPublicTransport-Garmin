import Toybox.Lang;
import Toybox.Time;
import Toybox.Graphics;

// The TfL API assigns numerical codes to each status severity, and it seems like you could *mostly* get by just
// treating lower numbers as being more severe, but that may not necessarily work in all cases. So below is a list of
// most severity descriptions observed at https://api.tfl.gov.uk/Line/Meta/Severity (excluding some that seem clearly
// only intended for use with stations, rather than lines), ordered roughly in the order of severity.
const SEVERITIES = {
	"Closed" => 0,
    "Service Closed" => 0,
	"No Service" => 0,
	"Not Running" => 0,
	"Planned Closure" => 0,
	"Suspended" => 1,
	"Part Closure" => 2,
	"Part Closed" => 2,
	"Part Suspended" => 3,
	"Severe Delays" => 4,
	// Special Service is used differently on different lines and can mean anything from minor delays to suspended.
	"Special Service" => 5,
	"Reduced Service" => 6,
	"Bus Service" => 7,
	"Change of frequency" => 8,
	"Diverted" => 9,
	"Issues Reported" => 10,
	"Minor Delays" => 11,
	"Information" => 12,
	"No Issues" => 13,
	"Good Service" => 14,
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

    function color() as Graphics.ColorType {
        if (internalSeverity < 5) {
            return TFL_RED;
        } else if (internalSeverity < 13) {
            return TFL_YELLOW;
        } else {
            return TFL_GREEN;
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
