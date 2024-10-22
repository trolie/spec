---
title: Pulling into the Station--TROLIE 1.0 Nears Journey's End
parent: Community Events
---

{: .announcement }
Join us on Wednesday November 20th, 2024 at 1:30pm ET for the webinar [A Lap Around TROLIE 1.0](javascript:alert('TODO'))!

# Pulling into the Station--TROLIE 1.0 Nears Journey's End

<img src="../images/trolie-station.jpg" style="float:right;padding-left:5px;box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3)" width="280" height="280"/>

The TROLIE 1.0 feature scope is essentially complete. We still have some tasks
to wrap up, including [documentation improvements](https://github.com/trolie/spec/milestone/8)
and [some small refinements to the media types](https://github.com/trolie/spec/milestone/7),
but the [use cases in 1.0 scope](#supported-use-cases) are satisfied by the current [spec](https://trolie.energy/spec).

Since our last [Community Post](../community-events/), we've accomplished a lot.

* Defined [RC-to-RC rating reconciliation](../articles/RC-to-RC-reconciliation.md) and the underlying
  [monitoring set reconciliation pattern](../articles/peer-monitoring-sets.md)
  which utilizes the affordances for [reading monitoring sets](https://trolie.energy/spec#tag/Monitoring-Sets)

* Defined a ["slim" media type pattern](../articles/media-types.md#slim-media-types) that optimizes the most
  common ratings and limits exchanges

* Defined operations for [temporary AAR exceptions](https://trolie.energy/spec#tag/Temporary-AAR-Exceptions)
  and [seasonal overrides](https://trolie.energy/spec#tag/Seasonal-Overrides)

* Incorporated myriad fixes and documentation improvements based on reviews with vendors.

## Supported Use Cases

Let's discuss these changes in terms of the use cases they support, starting with the
simplest conceptually, but perhaps the most difficult to specify.

### Seasonal Ratings

The concept of a [seasonal rating](../concepts.md#seasonal-ratings) differs
significantly from one grid operator to the next: Some operate to a seasonal
rating that changes monthly, while others are obliged to newly develop four
uniquely determined seasonal ratings per Order 881. Moreover, the calendar dates and times
that bracket these seasons can occur at any time in the calendar. Clearly there is
no canonical "Fall" when it comes to seasonal ratings. In fact, one Transmission Owner's Fall season
may begin and end at different times of year depending on the location of the transmission facility.

By examining the invariants of seasonal ratings, the TROLIE specification has
defined both a slim and detailed format for seasonal ratings proposals and
seasonal limits snapshots that is sufficiently general to address all of these
scenarios.

### Managing Temporary AAR Exceptions and Seasonal Overrides

Quoting the [specification](https://trolie.energy/spec#tag/Seasonal-Overrides):

> A Seasonal Override is an instruction to use a temporary static rating set in
> lieu of any concurrent Seasonal Rating for a given segment.
>
> A typical use case is a so-called "de-rate" due to temporary clearance issue
> for a transmission facility that is exempt from providing AARs. Exempt
> facilities normally operate against a seasonal rating, yet rather than provide a
> seasonal ratings schedule update, the Ratings Provider could send a Seasonal
> Override. During the provided duration of the override, the Transmission
> Provider would operate to the Seasonal Override rather than any ratings that
> would have been used from the seasonal rating schedule.
>
> In contrast, for a segment that is not exempt from providing AARs, the Ratings
> Provider would issue a Temporary AAR Exception to the Clearinghouse Provider to
> address a clearance issue or other temporary operating condition that calls for
> a static rating.

In previous community updates, we've called out Forecast and Real-Time use cases.
We include those here along with additional scenarios that have been addressed.

### Regional Clearing

On interties between Transmission Providers (TP), there is an additional timing
consideration.  While each TP will obtain the [locally-limiting ratings](../concepts.md#locally-limiting-rating) for their end of the tie on
their own time, in order to operate to the same [limits along the seam](../concepts.md#globally-limiting-rating), the TPs must exchange their
[regionally-limiting ratings](../concepts.md#regionally-limiting-rating)(RLRs) as soon as possible
after they've determined those RLRs.

TROLIE calls this [RC-to-RC Reconciliation](../articles/RC-to-RC-reconciliation.md).

### Forecasting Use Cases

* Submitting Forecast Ratings Proposals
* Obtaining Forecast Ratings Proposal Status
* Obtaining Forecast Limits Snapshots, including:
  - Normal snapshots that provide just the determined limits
  - Detailed snapshots that provide all of the inputs used by the Clearinghouse
    Provider to determine the limits, including all proposals and overrides.
* Slim proposals and snapshots that leverage information in the header to reduce the verbosity of the ratings / limits.

### Real-Time Use Cases

* Submitting Real-Time Ratings Proposals
* Obtaining Real-Time Ratings Proposal Status
* Obtaining Real-Time Limits Snapshots, including:
  - Normal snapshots that provide just the determined limits
  - Detailed snapshots that provide all of the inputs used by the Clearinghouse
    Provider to determine the limits, including all proposals and overrides.
* Slim proposals and snapshots that leverage information in the header to reduce the verbosity of the ratings / limits.


## Call to Action

* Calling all vendors! Please reach out to the maintainers with questions.
* Join the webinar on November 20th and bring your questions / concerns.
