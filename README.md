# London Public Transport for Garmin (LPTG)

LPTG is a Garmin Connect IQ widget that displays real-time London public transport information from the TfL API. It supports three features: Line Status, Arrivals, and Departures.

Each feature works with a different set of transport modes (bus, tube, etc). This reflects the capabilities of the underlying TfL API.


## Features

| Feature | Description | Supported Modes |
|---|---|---|
| Line Status | Current status of selected lines (Good Service, Minor Delays, Suspended, etc.) | Tube, Overground, Elizabeth Line, DLR, River Bus, Cable Car, Tram |
| Arrivals | Next arrivals at a configured stop, sorted by time | Bus, Tube, Tram |
| Departures | Upcoming departures from a configured station, with platform and status | Overground, Elizabeth Line, Thameslink |

Statuses are colour-coded: green = good service, yellow = moderate disruption, red = severe disruption or closure.

---

## Getting Started

Open the app on your watch. The main menu shows three options: **Line Status**, **Arrivals**, and **Departures**. Each must be configured before it can show data.

---

## Line Status

### Configuring lines

1. Select **Line Status** from the main menu.  If no stops are configured, the configuration menu opens automatically.
2. Select **Add** to see all available lines. Tap a line to add it.
3. To reorder or remove lines, tap an existing line in the config menu and choose **Move Up**, **Move Down**, or **Delete**.
4. Once you are satisfied with the configured lines, swipe right (or do whatever action is considered "back" on your device) to go back to the main menu.
5. You can always go back to the config menu by tapping the **header** in the Line Status list.

### Viewing line status

The list shows each configured line with its current status. If a line has multiple active statuses (for example, a line might have "Severe Delays" on part of the line and "Good Service" on the rest of the line), the most severe status will be displayed and the count of additional statuses is shown in brackets (e.g. *Severe Delays (+2)*).

Tap the **footer** (bottom area) to refresh. The last update time is shown in the footer.

Tap a line to see the full detail: each status is shown on its own page with a description and, where available, a reason for the disruption. Swipe up/down or use the page buttons to move between statuses for that line.

---

## Arrivals

Arrivals shows the next vehicles due at a stop, sorted by arrival time.

**NOTE**: An arrival prediction won't be displayed for a stop until the bus or train is actually en route. This means that a stop will never show predictions for services that start at that stop. For example, [Morden Underground Station](https://tfl.gov.uk/hub/stop/940GZZLUMDN/morden-underground-station/) (a terminus station for the Northern line) will display predictions for southbound Northern line services that terminate at Morden, but won't show any predictions for services going the other way. This is a limitation of the TfL API (see [here](https://techforum.tfl.gov.uk/t/how-to-find-departures-from-terminal-stations/72/54) for more information).

### Configuring stops

1. Select **Arrivals** from the main menu. If no stops are configured, the configuration menu opens automatically.
2. Select **Add** and type a search query (e.g. a stop name or road name). The app searches the TfL stop point database.
3. Select a result from the search list. For some stops (e.g. bus stations with multiple stands), you will be shown the individual stands — select the specific one you want.
4. Confirm the addition when prompted.
5. To reorder or remove stops, tap a stop in the config menu and choose **Move Up**, **Move Down**, or **Delete**.
6. You can always go back to the config menu by tapping the **header** in the Arrivals stop list.


### Using Arrivals

Select a stop from the list to load arrivals. The list shows each arriving vehicle with:
- The line name and time until arrival (e.g. *15 in 3m21s*)
- The ultimate destination of the service

Tap the **footer** (bottom area) to refresh. The last update time is shown in the footer.

---

## Departures

Departures shows upcoming train departures from a configured station, including platform and real-time status.

### Configuring stations

The process is the same as for Arrivals (see above). Search for a station name and confirm the addition.

### Using Departures

Select a station from the list to load departures. Each departure shows:
- The ultimate destination of the service
- A status string, for example:
  - `14:32 @ Platform 1` — on time, departing from Platform 1
  - `14:35 (sched. 14:32) @ Platform 1` — running late
  - `Cancelled` — service cancelled

Tap the **footer** (which displays the last update time) to refresh.

Tap a departure to see the full detail: scheduled time, estimated time (if different), status, and the cause of any delay or cancellation where provided. Note that the line/mode of the service (ie, Thameslink, or Elizabeth line or Overground line) is _not_ shown (this information is not returned by the TfL API).
