---
title: "Milestone: Forecasting API Stable"
parent: Community Events
---

# Forecasting API Stable

## Summary

<img src="../images/TROLIE-springtime.jpg" style="float:right;padding-left:5px;box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3)" width="280" height="280"/>

The specification of the [Forecasting operations](/spec#tag/Forecasting) in
TROLIE OpenAPI specification is now considered stable, closing the [associated
milestone](https://github.com/trolie/spec/milestone/1). Specifically, no further
changes are anticipated to the media type schemas and resource semantics--the
HTTP verbs, paths, and status codes--for submitting forecasts and retrieving
forecast snapshots.  We are naming this release `1.0.0-wip-forecasting-stable` to
reflect that fact that the specification is still under development, but we
believe the forecasting operations effectively address the use cases that have
been identified over the last several months.

## Stable Use Cases

Implementors should consider the specification stable in its support of the following use cases:

* Submitting Forecast Ratings Proposals
* Obtaining Forecast Ratings Proposal Status
* Obtaining Forecast Limits Snapshots, including:
  - "Slim" snapshots that provide just the determined limits
  - Detailed snapshots that provide all of the inputs used by the Clearinghouse
    Provider to determine the limits, including all proposals and overrides.

## Improved and Expanded Documentation

We continue to improve the documentation at [trolie.energy](/). In preparation
for this release, we have:

* Expanded the [TROLIE Concepts](../concepts) exposition
* Extended the guide on [Forecast
  Submittal](/example-narratives/submitting-forecasts)
* Added an article on [Conditional GET](/articles/conditional-GET) and how to use
  it to obtain snapshots efficiently
* Described [how units are handled](/articles/how-units-are-handled) to
  accommodate different practices by Reliability Coordinators
* Added a concise description of [Forecast Windows](/articles/forecast-windows) and how
  late forecast submissions are handled
* Added a decision record on [Network Element Names and Naming
  Authorities](/decision-log/naming) that describes how TROLIE addresses the
  realities of different entities using different names for the same equipment.
* Added a decision record on [directional ratings](/decision-log/directional-ratings).

## Looking Ahead

The [next milestone](https://github.com/trolie/spec/milestone/2) will stabilize
Real-Time Ratings Proposals. [Future
milestones](https://github.com/trolie/spec/milestones) will include handling
temporary AAR exceptions, seasonal ratings, and defining the [peering
profile](https://github.com/trolie/spec/issues/65#issuecomment-1994413248) which
will specify how TROLIE implementations will integrate using only some
simple configuration.

The specification will be updated accordingly **without** a version change until
the next milestone is completed, remaining at `1.0.0-wip-forecasting-stable` 
even as the Real-Time Ratings Proposals milestone is completed. However, any necessary
changes to the forecasting operations will result in a version change and
another announcement.
