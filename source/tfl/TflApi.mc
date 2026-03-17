import Toybox.Communications;
import Toybox.Lang;
import Toybox.Time;

// Line IDs for all lines that support `/ArrivalDepartures` API endpoint.
const _DEPARTURE_LINE_IDS = "thameslink,elizabeth,liberty,lioness,mildmay,suffragette,weaver,windrush";

class TflApi {

    // Generic function to make a GET request to the TFL API, which is used by the
    // other endpoint-specific methods.
    private function makeRequest(url as String, params as Dictionary, callback as Method) {
        System.println("Calling url: " + url);
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "User-Agent" => USER_AGENT
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        //System.println("Options: " + options.toString());

        Communications.makeWebRequest(url, params, options, callback);
    }

    // Get the status of the given lines.
    function getLineStatuses(lines as Array<String>, callback as Method) {
        var ids = joinArray(lines, ',');
        var url = BASE_URL + "/Line/" + ids + "/Status";
        //var params = { "detail" => true };
        var params = {};
        makeRequest(url, params, callback);
    }

    // Get the status of all lines for the given modes.
    function getModeLineStatuses(modes as Array<String>, callback as Method) {
        var modeIds = joinArray(modes, ',');
        var url = BASE_URL + "/Line/Mode/" + modeIds + "/Status";
        //var params = { "detail" => true };
        var params = {};
        makeRequest(url, params, callback);
    }

    // Get arrival predictions for the given stop point.
    // `id`: The NAPTAN ID of the stop point.
    // `callback`: Function to be called with the data fetched from the API.
    function getStopPointArrivals(id as String, callback as Method) {
        var url = BASE_URL + "StopPoint/" + id + "/Arrivals";
        var params = {};
        makeRequest(url, params, callback);
    }

    // Get departure predictions for the given stop point.
    function getStopPointDepartures(id as String, callback as Method) {
        var url = BASE_URL + "StopPoint/" + id + "/ArrivalDepartures?lineIds=" + _DEPARTURE_LINE_IDS;
        var params = {};
        makeRequest(url, params, callback);
    }

    // Search stop points by common name.
    function searchStopPoints(
        query as String,
        modeIds as Array<String>?,
        lineIds as Array<String>?,
        callback as Method
    ) {
        var url = BASE_URL + "StopPoint/Search/" + query + "?includeHubs=false";
        if (modeIds != null) {
            url += "&modes=" + joinArray(modeIds, ",");
        }
        if (lineIds != null) {
            url += "&lines=" + joinArray(lineIds, ",");
        }
        var params = {};
        makeRequest(url, params, callback);
    } 

    // Get detailed information for the stop point identified by the given ID.
    function getStopPoint(id as String, callback as Method) {
        var url = BASE_URL + "StopPoint/" + id;
        var params = {};
        makeRequest(url, params, callback);
    }

}

var _tflApi = null;
function getTflApi() as TflApi {
    if (_tflApi == null) {
        _tflApi = new TflApi();
    }
    return _tflApi;
}