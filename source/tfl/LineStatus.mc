import Toybox.Lang;
import Toybox.Time;
import Toybox.Graphics;

// Basic information about a line that is supported by the TFL API.
class TflLine {
    // The line id that is used to identify it in the TFL API.
    public var id as String;
    // The human-readable name of the line.
    public var name as String;

    function initialize(id as String, name as String) {
        self.id = id;
        self.name = name;
    }
}

class LineWithMode {
    public var line as TflLine;
    // The human-readable name of the mode served by the line. This can be `null`
    // if the relevant mode only has one line and therefore it doesn't make sense
    // to separately display the mode to the user.
    public var modeName as String?;

    function initialize(line as TflLine, modeName as String?) {
        self.line = line;
        self.modeName = modeName;
    }
}

// Line which are supported for the line status feature. Hard-coded to avoid
// having to make additional requests to the API. Both as an array to preserve
// order and a dictionary for quick look-up. Bus routes are excluded as
// there are hundreds of them which makes configuration difficult, and they
// typically only show "Good Service" or "Special Service" so a short status
// report is less useful.
const SUPPORTED_LWMS = [
    new LineWithMode(new TflLine("bakerloo", "Bakerloo"), "Tube"),
    new LineWithMode(new TflLine("central", "Central"), "Tube"),
    new LineWithMode(new TflLine("circle", "Circle"), "Tube"),
    new LineWithMode(new TflLine("hammersmith-city", "Hammersmith & City"), "Tube"),
    new LineWithMode(new TflLine("jubilee", "Jubilee"), "Tube"),
    new LineWithMode(new TflLine("metropolitan", "Metropolitan"), "Tube"),
    new LineWithMode(new TflLine("northern", "Northern"), "Tube"),
    new LineWithMode(new TflLine("piccadilly", "Piccadilly"), "Tube"),
    new LineWithMode(new TflLine("victoria", "Victoria"), "Tube"),
    new LineWithMode(new TflLine("waterloo-city", "Waterloo & City"), "Tube"),
    new LineWithMode(new TflLine("dlr", "DLR"), null),
    new LineWithMode(new TflLine("elizabeth", "Elizabeth Line"), null),
    new LineWithMode(new TflLine("liberty", "Liberty"), "Overground"),
    new LineWithMode(new TflLine("lioness", "Lioness"), "Overground"),
    new LineWithMode(new TflLine("mildmay", "Mildmay"), "Overground"),
    new LineWithMode(new TflLine("suffragette", "Sufragette"), "Overground"),
    new LineWithMode(new TflLine("weaver", "Weaver"), "Overground"),
    new LineWithMode(new TflLine("windrush", "Windrush"), "Overground"),
    new LineWithMode(new TflLine("london-cable-car", "Cable Car"), null),
    new LineWithMode(new TflLine("tram", "Tram"), null),
    new LineWithMode(new TflLine("rb1", "RB1"), "River Bus"),
    new LineWithMode(new TflLine("rb4", "RB4"), "River Bus"),
    new LineWithMode(new TflLine("rb6", "RB6"), "River Bus"),
    new LineWithMode(new TflLine("woolwich-ferry", "Woolwich Ferry"), "River Bus")
];

var _supportedLwmDict = null;
function getSupportedLwmDict() as Dictionary<String, LineWithMode> {
    if (_supportedLwmDict == null) {
        _supportedLwmDict = {};
        for (var i = 0; i < SUPPORTED_LWMS.size(); i++) {
            var lwm = SUPPORTED_LWMS[i];
            _supportedLwmDict[lwm.line.id] = lwm;
        }
    }
    return _supportedLwmDict;
}

function getLwmById(id as String) as LineWithMode? {
    return getSupportedLwmDict()[id];
}

// Convert a list of line IDs to a dictionary mapping those IDs to the
// relevant `Line` objects
function lineIdsToLwms(lineIds as Array<String>) as Dictionary<String, LineWithMode> {
    var dict = {};
    for (var i = 0; i < lineIds.size(); i++) {
        var lineId = lineIds[i];
        var line = getSupportedLwmDict()[lineId];
        if (line != null) {
            dict[lineId] = line;
        }
    }
    return dict;
}

// A general categorisation of how severe a status is.
enum SeverityLevel {
    LOW = 1,
    MODERATE = 2,
    HIGH = 3
}

// A mapping of known status descriptions to their severity levels.
// Only those considered low severity or high severity are explicitly included;
// any description not included in the dictionary is considered moderate severity.
// The different severities can be found at https://api.tfl.gov.uk/Line/Meta/Severity
const SEVERITY_LEVELS = {
    "Closed" => HIGH,
    "Service Closed" => HIGH,
    "No Service" => HIGH,
    "Not Running" => HIGH,
    "Planned Closure" => HIGH,
    "Suspended" => HIGH,
    "Part Closure" => HIGH,
    "Part Closed" => HIGH,
    "Part Suspended" => HIGH,
    "Severe Delays" => HIGH,
    "No Issues" => LOW,
    "Good Service" => LOW

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
    public var severityLevel as SeverityLevel;  // Status severity according to `SEVERITIES` lookup
    public var description as String;
    public var reason as String?;
    public var validityPeriods as Array<ValidityPeriod>;
    public var affectedRoutes as Array<AffectedRoute>;

    function initialize(dict as Dictionary) {
        apiSeverity = dict["statusSeverity"];
        description = dict["statusSeverityDescription"];
        severityLevel = SEVERITY_LEVELS[description] ? SEVERITY_LEVELS[description] : MODERATE;
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
        if (severityLevel == LOW) {
            return TFL_GREEN;
        } else if (severityLevel == HIGH) {
            return TFL_RED;
        } else {
            return TFL_YELLOW;
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
            if (mostSevere == null || s.severityLevel > mostSevere.severityLevel) {
                mostSevere = s;
            }
        }
        return mostSevere;
    }
}

function lineStatusDataDict(data as Array<Dictionary>) as Dictionary<String, TflLine> {
    var dict = {};
    for (var i = 0; i < data.size(); i++) {
        var lineStatusData = new LineStatusData(data[i]);
        dict[lineStatusData.id] = lineStatusData;
    }
    return dict;
}