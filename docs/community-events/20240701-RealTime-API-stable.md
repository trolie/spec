---
title: "Milestone: Real-Time API Stable"
parent: Community Events
---

# Real-Time API Stable

## Summary

<img src="../images/TROLIE-summer.jpg" style="float:right;padding-left:5px;box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3)" width="280" height="280"/>

The specification of the [Real-Time Operations](/spec#tag/Real-Time) in
TROLIE OpenAPI specification is now considered stable, closing the [associated
milestone](https://github.com/trolie/spec/milestone/2). Specifically, no further
changes are anticipated to the media type schemas and resource semantics--the
HTTP verbs, paths, and status codes--for submitting ratings and retrieving
in-use limit snapshots.  We are naming this release `1.0.0-wip-realtime-stable` to
reflect that fact that the specification is still under development, but we
believe the real-time operations effectively address the use cases that have
been identified over the last several months.

This is effectively similar to the previous announced [Forecasting](20240330-Forecast-API-stable) 
milestone as an incremental step towards TROLIE 1.0.0.

## Stable Use Cases

Implementors should consider the specification stable in its support of the following use cases:

* Submitting Real-Time Ratings Proposals
* Obtaining Real-Time Ratings Proposal Status
* Obtaining Real-Time Limits Snapshots, including:
  - ~~Slim~~ Normal snapshots that provide just the determined limits
  - Detailed snapshots that provide all of the inputs used by the Clearinghouse
    Provider to determine the limits, including all proposals and overrides.

## Improved and Expanded Documentation

We continue to improve the documentation at [trolie.energy](/). In preparation
for this release, we have:

* Continued additions to the [TROLIE Concepts](../concepts) exposition
* Added example guides for real-time API usage [Querying in-use Real-Time Limits](/example-narratives/in-use-realtime-limits) and [Real-Time Rating Submittal](/example-narratives/submitting-realtime-ratings)

## Looking Ahead

[Future
milestones](https://github.com/trolie/spec/milestones) will include handling
temporary AAR exceptions, seasonal ratings, and defining the [peering
profile](https://github.com/trolie/spec/issues/65#issuecomment-1994413248) which
will specify how TROLIE implementations will integrate using only some
simple configuration.

The specification will be updated accordingly **without** a version change until
the next milestone is completed, remaining at `1.0.0-wip-realtime-stable` 
even as future milestones is completed. However, any necessary
changes to the forecasting operations will result in a version change and
another announcement.
