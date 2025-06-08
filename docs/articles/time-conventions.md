---
title: Time Conventions in TROLIE
parent: Articles
---

# How Time is Represented
Time is represented in TROLIE in one of two ways, depending on the operation:

* For most operations, time is represented using RFC 3339 timestamps.  This is a standard format for timestamp strings used widely on the internet, and supported by most programming languages.  This format explicitly declares the assumed offset from UTC, such as in `2025-11-02T01:00:00-05:00`.  This is a representation of the local timezone _at the time relevant to this timestamp_.  Programming environments such as Java, .NET, Python, and the C++ Boost Time library will convert these back and forth from UTC-based times in code seamlessly.  This is key to the ability to smoothly transition daylight savings as described in [How Daylight Savings is Handled](daylight-savings.md).
* For [slim formats](../example-narratives/using-slim-media-types.md) specifically targeting forecast ratings, _hours_ are represented by positional index from the start and end interval.  For example, given a forecast proposal submission starting at `2025-07-02T01:00:00-05:00`, the first period represents `2025-07-02T01:00:00-05:00`, the second period represents `2025-07-02T02:00:00-05:00` and so on.  


## Timestamp Ordering in JSON Documents
For any request or response body that represents collections of time using 
RFC 3339 timestamps in TROLIE, such as 
[getLimitsForecastSnapshot](../spec-1.0#tag/Forecasting/operation/getLimitsForecastSnapshot) or 
[getSeasonalRatingsSnapshot](../spec-1.0#tag/Seasonal/operation/getSeasonalRatingsSnapshot),
timestamps must always be rendered in chronological order by both clients and servers.  This way, 
applications can optimize around an assumed ordering and do not need to proactively sort the data
by time.  The output is also more readable.  

## Forecast Proposals Must Include the Complete Set of Periods in the Ratings Obligation
For a particular [Forecast Window](forecast-windows.md), ratings providers are required to submit
the complete forecast required by the Transmission Provider in a single call to 
[patchRatingForecastProposal](../spec-1.0#tag/Forecasting/operation/patchRatingForecastProposal).  In
other words, if the Transmission Provider requires 240 hours to be submitted, which is most common per the 
FERC order, then _all_ 240 hours must be submitted on one request, or the TROLIE server will reject the 
forecast.  The TROLIE specification _does_ allow for the rating proposal to be broken across requests
in terms of resources.  For example, if a ratings provider is obligated to send ratings for 10 resources, 
then they may choose to send forecasts for 5 of those resources in one request, then the other 5 resources in
another.  However, each request must contain the complete set of 240 hours worth of ratings for the resources
included within.  

## Granularity of RFC 3339 Times in Forecasts
RFC 3339 is used for forecasts specifically to avoid locking the specification to _only_ accept forecasts in 
terms of hours.  The FERC order specifically states that the forecasts must be _at least_ hourly, implying
there may be scenarios in the future where sub-hourly forecasts could make sense.  

However, as of the release of the TROLIE specification 1.0 in late 2024, all US ISOs 
will only use hours.  Ratings Providers should check with their TROLIE peers to be sure, but use of hours and
_only_ hours is typical.