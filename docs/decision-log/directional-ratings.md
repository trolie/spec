---
title: Directional Ratings
parent: Decision Records
---

## Status

* Status: `proposed`
* Issue Link: [GitHub Issue](https://github.com/trolie/spec/issues/6)

## Context
Most lines only require a single set of rating values that apply irregardless 
of the direction that energy is flowing. However, for some lines, 
Transmission Providers may require separate "directional" ratings that 
differ depending on the direction energy is flowing.  

This decision documents strategy for representing directional ratings in TROLIE.  

## Decision
TROLIE will contain no specific schema elements to represent directional ratings.
For lines that require directional ratings, TROLIE servers must expose unique
resource identifiers representing each direction.  

### A Rating Direction as a Resource
While a rating direction against a particular piece of equipment doesn't map directly
back to the physical model, it is a natural fit for TROLIE implementations to consider
each direction as a separate anchor against which TROLIE servers can attach ratings.  Each 
direction could have its obligation tracked for providing ratings data separately, as it
is possible that values for each direction could be provided independently.  In addition,
it is safe to assume that many systems will represent the ratings over time as a time 
series, both to meet FERC's 5-year history requirement and for other study purposes.  It
is convenient to simply represent the ratings as a single time series per resource,
vs a time series per resource per direction.  

An alternative would be to mark each series with explicit directions in the model, 
including a special value for "both" when directional ratings don't apply.  We feel this
would add extra complexity to the model to accommodate the minority of devices
on the system, and is the wrong tradeoff.  

### Directional-Resource Naming
While directional ratings are supported by many systems involved in grid 
operations (EMS, Markets, modeling etc), there is currently no consistent approach 
to how they are represented.  IEC CIM also has no provision for directional
ratings in the transmission model as of version 17.  So, there is no existing
standard to gravitate to.  

Much like the [rules on naming](naming.md), TROLIE will need to be flexible in order
to accommodate the inertia of established software systems, models and methodologies.
Therefore, TROLIE is not opinionated on how these names are structured.  Some possible
examples are simply listed in the examples section to provide guidance, as referenced
below.  

## Consequences
TROLIE server implementations are responsible for translating resources into rating
directions, and exposing identifiers that represent each direction.  Some possible
examples are provided [here](../example-narratives/in-use-forecasts.md) for guidance.
