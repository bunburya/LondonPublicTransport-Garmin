import Toybox.Communications;
import Toybox.Lang;
import Toybox.Time;

class TflApi {

    // Generic function to make a GET request to the TFL API, which is used by the
    // other endpoint-specific methods.
    private function makeRequest(url as String, params as Dictionary, callback as Method) {
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "User-Agent" => USER_AGENT
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

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
    // `name`: The common name of the stop point.
    // `callback`: Function to be called with the data fetched from the API.
    function getStopPointArrivals(id as String, callback as Method) {
        var url = BASE_URL + "StopPoint/" + id + "/Arrivals";
        System.println("Calling url: " + url);
        var params = {};
        makeRequest(url, params, callback);
    }

    function searchStopPoints(query as String, callback as Method) {
        // TODO
    } 

}