---
title: Conditional Seasonal Ratings
parent: Decision Records
---

## Status

* Status: `Specification-in-progress`
* Issue Link: [GitHub Issue](https://github.com/trolie/spec/issues/129)

## Context

There are certain transmission lines that can have different ratings depending on their 
configuration. The most frequent examples are underwater lines with cables packed tightly in 
trays, where certain combinations of the conductors may be turned on and off. Switching 
conductors on and off obviously changes the amount of copper that can carry 
electrons. However, to add additional complexity, the wires are close enough together
that they can heat each other up as well, and the overall rating must take this into 
account. Therefore, each possible combination will have a unique rating.

When computing AARs however, it is necessary to take the configuration into account
so that the AAR accounts for the actual or forecasted configuration of the line.  Therefore,
no special accommodation needs to be considered for AAR exchange in TROLIE.  

However, for seasonal ratings, the configuration of the line cannot be 
forecasted accurately for use as a recourse rating. A separate rating must be 
provided for each configuration, so that the right rating may be used based on the 
configuration of the line.  

This decision records a strategy for these "conditional" ratings in TROLIE.  

## Decision

TROLIE will contain no specific schema elements to represent conditional ratings.
For lines that require conditional ratings, TROLIE servers must expose unique
resource identifiers representing each condition / permutation of the configuration. 

This follows from the similar precedent set by the decision 
for [directional ratings](directional-ratings.md).

### Conditional-Resource Naming
Much like the problem in naming directional ratings, there is currently no consistent 
approach as to how these "conditions" are represented.  TROLIE implementations will
be left on their own to implement a convention for these names, likely concatenating
the facility ID with an ID for each possible condition.  


## Consequences

TODO: Link to an example article once the seasonal rating structure is complete.  