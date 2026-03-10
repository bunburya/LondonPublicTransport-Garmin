import Toybox.Lang;
import Toybox.WatchUi;

class StopPointSearchResultsDelegate extends WatchUi.Menu2InputDelegate {
    private var _stopPoints as Array<StopPoint>;
    private var _storageKey as StorageKey;
    private var _isChild as Boolean;
    private var _modes as Array<String>;

    function initialize(
        stopPoints as Array<StopPoint>,
        storageKey as StorageKey,
        isChild as Boolean,
        modes as Array<String>
    ) {
        WatchUi.Menu2InputDelegate.initialize();
        _stopPoints = stopPoints;
        _storageKey = storageKey;
        _isChild = isChild;
        _modes = modes;
    }

    function onSelect(item as MenuItem) as Void {
        var sp = _stopPoints[item.getId() as Number];
        System.println("StopPointSearchResultsDelegate.onSelect called");
        System.println("id: " + sp.toString());
        if (_isChild || (sp.parentId != null && sp.parentId != sp.id)) {
            // If _isChild is true, then _stopPoints is a list of child stops,
            // which should aready have the relevant details included. So we
            // don't need to request them from the API (and shouldn't, as
            // requesting details of a child StopPoint will just return the
            // same results as its parent StopPoint).

            // If parentId is present and different to the stop points's own
            // id, it means we likely have a child of a hub or collection of
            // stops. This means calling `/StopPoint/<id>` will return details
            // of the parent hub, which can sometimes be too large. So instead
            // we just display the data we have. 
            var text = sp.name;
            if (sp.indicator != null) {
                text += "\n" + sp.indicator;
            }
            var view = new WatchUi.Confirmation(text);
            var delegate = new AddStopPointConfirmDelegate(_storageKey, sp);
            WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
        } else {
            // If _isChild is false, we need to request further details (eg,
            // indicator) of the relevant StopPoint.
            var view = new AddStopPointConfirmLoadingView(_storageKey, sp, _isChild, _modes);
            WatchUi.pushView(view, null, SLIDE_IMMEDIATE);
        }
    }
}