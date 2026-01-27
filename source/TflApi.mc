import Toybox.System;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.PersistedContent;

const BASE_URL = "https://api.tfl.gov.uk/";

class TflApi {

    public var statusMessage = "";
    public var errorMessage = "";
    var lineStatuses as Array<Dictionary> = [];

    // Get the status of the given lines.
    function getLineStatuses(lines as Array<String>) {
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

        Communications.makeWebRequest(url, params, options, method(:onReceiveLineStatuses));

        statusMessage = "Requesting...";
        WatchUi.requestUpdate();
    }

    // Get the status of all lines for the given modes.
    function getModeLineStatuses(modes as Array<String>) {
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

        Communications.makeWebRequest(url, params, options, method(:onReceiveLineStatuses));

        statusMessage = "Requesting...";
        WatchUi.requestUpdate();
    }

    function onReceiveLineStatuses(responseCode as Number, data as Dictionary) as Void {
        if (responseCode == 200) {
            statusMessage = "Success!";
            if (data != null) {
                if (data.size() > 0) {
                    data = data as Array<Dictionary>;
                    lineStatuses = data;
                } else {
                    errorMessage = "No data available.";
                    lineStatuses = [];
                }
            } else {
                errorMessage = "No data received.";
            }
        } else {
            statusMessage = "Error: " + responseCode;
        }

        WatchUi.requestUpdate();
    }

    // function currentLineStatus() as Dictionary? {
    //     if (_lineStatusIdx == null) {
    //         return null;
    //     } else {
    //         return _lineStatuses[_lineStatusIdx];
    //     }
    // }

    // function nextLineStatus() as Dictionary? {
    //     if (_lineStatusIdx != null && _lineStatusIdx < _lineStatuses.size()) {
    //         _lineStatusIdx += 1;
    //         return currentLineStatus();
    //     } else {
    //         return null;
    //     }
    // }

    // function prevLineStatus() as Dictionary? {
    //     if (_lineStatusIdx != null && _lineStatusIdx > 0) {
    //         _lineStatusIdx -= 1;
    //         return currentLineStatus();
    //     } else {
    //         return null;
    //     }
    // }


}