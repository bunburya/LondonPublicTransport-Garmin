import Toybox.Lang;
import Toybox.WatchUi;

class StopPointSearchResultsDelegate extends WatchUi.Menu2InputDelegate {
    private var _stopPoints as Array<StopPoint>;
    private var _isChild as Boolean;
    private var _modes as Array<String>;

    function initialize(stopPoints as Array<StopPoint>, isChild as Boolean, modes as Array<String>) {
        WatchUi.Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
        _isChild = isChild;
        _modes = modes;
    }

    function onSelect(item as MenuItem) as Void {
        var sp = _stopPoints[item.getId() as Number];
        System.println("StopPointSearchResultsDelegate.onSelect called");
        System.println("id: " + sp.toString());
        if (_isChild) {
            // If _isChild is true, then _stopPoints is a list of child stops,
            // which should aready have the relevant details included. So we
            // don't need to request them from the API (and shouldn't, as
            // requesting details of a child StopPoint will just return the
            // same results as its parent StopPoint).
            var text = sp.name;
            if (sp.indicator != null) {
                text += "\n" + sp.indicator;
            }
            var view = new WatchUi.Confirmation(text);
            var delegate = new AddStopPointConfirmDelegate(ARRIVALS_STOPPOINTS, sp);
            WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
        } else {
            // If _isChild is false, we need to request further details (eg,
            // indicator) of the relevant StopPoint.
            var view = new AddStopPointConfirmLoadingView(ARRIVALS_STOPPOINTS, sp, _isChild, _modes);
            WatchUi.pushView(view, null, SLIDE_IMMEDIATE);
        }
    }
}