import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application;

class AddStopPointConfirmLoadingView extends BaseLoadingView {
    private var _storageKey as StorageKey;
    private var _stopPoint as StopPoint;
    
    function initialize(storageKey as StorageKey, stopPoint as StopPoint) {
        BaseLoadingView.initialize();
        _storageKey = storageKey;
        _stopPoint = stopPoint;
    }

    function onShow() {
        getTflApi().getStopPoint(_stopPoint.id, method(:onReceive));
    }

    function onReceive(responseCode as Number, data as Dictionary) {
        System.println("AddStopPointConfirmLoadingView onReceive called");
        if (!validateResponse(responseCode, data)) {
            return;
        }
        var sp = StopPoint.fromDict(data);
        var text = sp.name + " " + sp.id;
        var view = new WatchUi.Confirmation(text);
        var delegate = new AddStopPointConfirmDelegate(_storageKey, sp);
        WatchUi.switchToView(view, delegate, SLIDE_IMMEDIATE);
    }


}

class AddStopPointConfirmDelegate extends WatchUi.ConfirmationDelegate {
    private var _storageKey as StorageKey;
    private var _stopPoint as StopPoint;

    function initialize(storageKey as StorageKey, stopPoint as StopPoint) {
        WatchUi.ConfirmationDelegate.initialize();
        _storageKey = storageKey;
        _stopPoint = stopPoint;
        System.println("AddStopPointConfirmDelegate initialised");
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            addStopPoint(_stopPoint, _storageKey);
            return true;
        }
        return false;
    }
}