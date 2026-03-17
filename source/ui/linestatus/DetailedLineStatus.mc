import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

// Factory that creates text pages
class DetailedLineStatusViewFactory extends WatchUi.ViewLoopFactory {
    private var _statuses as Array<LineStatus>;

    function initialize(statusData as LineStatusData) {
        ViewLoopFactory.initialize();
        _statuses = statusData.statuses; 
    }

    function getSize() {
        return _statuses.size();
    }

    function getView(idx as Number) {
        var lineStatus = _statuses[idx];

        var body;
        if (lineStatus.reason != null) {
            body = lineStatus.reason;
        } else {
            body = Rez.Strings.NoFurtherInfo;
        }
        
        var view = new InfoView(lineStatus.description, lineStatus.color(), body);
        var delegate = new InfoDelegate(view);
        return [view, delegate];
    }
}
