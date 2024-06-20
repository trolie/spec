---
title: Real-Time and Forecast Ratings as Distinct Data Sets
parent: Decision Records
---

## Status

* Status: `Committed`
* Issue Link: [GitHub Issue](https://github.com/trolie/spec/issues/100)

## Context

The primary driver for TROLIE is exchange of the 240-hour-ahead forecast AAR
data as required by FERC 881.  While the ability to forecast data is new with
the FERC order, the ability to have line ratings that change based on
temperature is a technology that has been around for some time, if not used in
such a ubiquitous way mandated by the order.

However, some Transmission Providers may interpret the first of that 240 hours
as being the "current" hour (aka hour "0").  This is not naturally a forecast.
Since this first hour is to be used in real-time operations, therefore
representing the current time, it should be based on observed ambient
conditions, rather than weather forecasts.  Since this data is used for
real-time operations and most commonly represents the latest observed vs
forecast state, TROLIE refers to these as `Real-Time` ratings.

Traditional real-time AAR/DLR systems have used SCADA telemetry protocols for
ratings exchange.  Since real-time ratings are derived from observed weather
measurements, fitting them into the "measurement"-oriented model used by these
protocols is somewhat natural.  Existing ratings exchanges between Transmission
Providers and Ratings Providers typically use ICCP for this purpose.  TROLIE
must assume this method will continue to exist as part of the FERC 881
landscape.

TROLIE could take various stances on real-time ratings.  Obvious options
include:

* Ignore them entirely, assuming that all real-time rating exchange is the
  domain of SCADA protocols such as ICCP.
* Pack them into the forecast payload, so that the first hour (hour 0)
  implicitly represents real-time ratings.
* Model them as a separate concept altogether.

Note that any use of real-time ratings in TROLIE scope must not be mutually
exclusive to ICCP usage.  In practice, ICCP will stay around, so TROLIE would
serve as an optional alternative for some users to submit ratings, and/or an
alternate way to get current in-use limits.

This decision documents strategy for representing real-time ratings in TROLIE.

## Decision

TROLIE will include a real-time ratings operations and a real-time ratings
clearing house that is distinct from the one for forecast ratings, but uses
similar concepts.

### Why Expose Real-Time Ratings to TROLIE?

Many of the structural advantages of the REST technology used by TROLIE over
traditional OT data exchanges are documented in this
[article](../articles/trolie-for-ems-and-ot.md).  While real-time ratings do map
more naturally to SCADA protocols, there are still some advantages in terms of
the flexibility of the data structure.  For example, real-time limit snapshots
include a "detailed" media type much like the forecast ratings do, which would
be prohibitively difficult to model over ICCP.  In addition, some transmission
providers may decide that this data is best offloaded from their SCADA systems
and ICCP gateways as those systems scale and are challenged by other changes in
the power grid.  Finally, this becomes accessible for rating provider systems
that do not have easy access to ICCP gateways, which are expensive to install
and may be difficult to justify only for ratings exchange.

### Optional Support Scenarios

Not all TROLIE implementations will be required to support real-time ratings.
They must be able to coexist alongside ICCP implementations, and some grid
operators may elect to only use ICCP, only use TROLIE, or use both for different
ratings providers.  In addition, TROLIE implementations may elect to support
read of real-time snapshots for transparency uses or downstream readers, but
*not* the submission of real-time proposals.

### Real-Time Ratings as a Distinct Data Exchange

Rather than implicitly pack real-time ratings into "hour 0" in the forecast,
TROLIE separates real-time ratings into a distinct data exchange.  There are
several reasons for this:

* The concepts (forecast and real-time) have misalignments that make them
  awkward to use together.  For example, there isn't necessarily a "time"
  associated with the real-time ratings; new proposal values are simply
  reflections of the latest measurements.  By making the differences explicit,
  we can make the separate data exchanges more semantically direct, and
  therefore simpler.

* The reasonable frequency for producing real-time ratings is very different
  than for forecast ratings.  There is likely no reason to publish forecasts
  more than once an hour, as updated forecasts are unlikely to improve accuracy.
  In contrast, real-time ratings are based on real, observed temperature
  changes, which _can_ certainly change within the hour.  This increased
  frequency also allows TROLIE to support DLRs as well as AARs, as changes to
  real-time proposals could simply be conveyance of sensor data.

* The usage of forecast and real-time ratings by the ratings provider is also
  quite different.  Real-time ratings are forwarded on to state estimator,
  real-time markets and generation dispatch processes.  These processes run
  frequently and react to new ratings at a much finer granularity than one hour.
  Forecast ratings, however, are used in slower processes, such as look-ahead
  unit commitment and dispatch, day-ahead markets, outage coordination, and
  transmission scheduling.  These processes are less able, if they are able at
  all, to leverage data generated at a finer frequency than one hour.

Note that this does not prohibit a transmission provider and TROLIE server
implementation from using the first hour of a forecast in place of a real-time
rating if no such feed is available.


## Consequences

TROLIE real-time operations are defined under the `Real-Time` tag of the TROLIE
[specification](https://trolie.energy/spec#tag/Real-Time).  As mentioned above,
TROLIE servers may optionally implement these operations.
