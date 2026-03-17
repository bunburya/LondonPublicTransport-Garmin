import Toybox.WatchUi;
import Toybox.Lang;

// A base class for a basic "Loading..." screen. Other classes can extend
// this class to add API requests and callbacks.
class BaseLoadingView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_MEDIUM,
            "Loading...",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    // Check that the response received from the server is valid (response
    // code is OK and data is non-null). If response is invalid, this function
    // will display an error message, pop the view and return false.
    function validateResponse(responseCode, data) as Boolean {
        var errorMessage = null;
        if (responseCode != 200) {
            errorMessage = WatchUi.loadResource(Rez.Strings.BadHttpResponse) + ": " + responseCode;
        } else if (data == null) {
            errorMessage = Rez.Strings.NoDataReceived;
        }

        if (errorMessage != null) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            WatchUi.showToast(errorMessage, null);
            return false;
        }
        return true;
    }

}
