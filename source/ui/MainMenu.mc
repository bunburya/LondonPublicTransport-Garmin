import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class MainMenuView extends WatchUi.Menu2 {
    function initialize() {
        var footer = WatchUi.loadResource(Rez.Strings.AppName)
            + " v"
            + WatchUi.loadResource(Rez.Strings.AppVersion);
        WatchUi.Menu2.initialize({
            :title => Rez.Strings.MainMenuHeader,
            :footer => footer
        });
        addItem(new MenuItem(
            Rez.Strings.LineStatusMenuLabel,
            Rez.Strings.LineStatusMenuSubLabel,
            :line_status,
            {}
        ));
        addItem(new MenuItem(
            Rez.Strings.ArrivalsMenuLabel,
            Rez.Strings.ArrivalsMenuSubLabel,
            :arrivals,
            {}
        ));
        addItem(new MenuItem(
            Rez.Strings.DeparturesMenuLabel,
            Rez.Strings.DeparturesMenuSubLabel,
            :departures,
            {}
        ));
        addItem(new MenuItem(
            Rez.Strings.SettingsMenuLabel,
            null,
            :settings,
            {}
        ));
    }
}

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) {
        var id = item.getId();
        if (id == :line_status) {
            WatchUi.pushView(new StatusListLoadingView(), null, WatchUi.SLIDE_LEFT);
        } else if (id == :arrivals) {
            var stopPoints = loadStopPoints(ARRIVALS_STOPPOINTS);
            var view = new ArrivalsSplocView(
                stopPoints,
                Rez.Strings.ConfigArrivalStops
            );
            var delegate = new ArrivalsSplocDelegate(
                stopPoints,
                Rez.Strings.ConfigArrivalStops
            );
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else if (id == :departures) {
            var stopPoints = loadStopPoints(DEPARTURES_STOPPOINTS);
            var view = new DeparturesSplocView(
                stopPoints,
                Rez.Strings.ConfigDepartureStops
            );
            var delegate = new DeparturesSplocDelegate(
                stopPoints,
                Rez.Strings.ConfigDepartureStops
            );
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else if (id == :settings) {
            WatchUi.pushView(new Rez.Menus.SettingsMenu(), new SettingsMenuDelegate(), SLIDE_RIGHT);
        }
    }
}