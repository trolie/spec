---
title: TROLIE Concepts
nav_order: 2
---

# TROLIE Concepts

Before reviewing examples, users may benefit from a basic understanding of the key constructs used by the TROLIE APIs.  Definitions of these concepts are included here.  

![UML concept model](<images/data model.excalidraw.png>)

## Transmission Facilities
A Transmission Facility is a logical part of the electrical network that may have a rating, whether simply seasonal or an AAR.  This most often represents a transmission line, but could also include transformers and other large pieces of equipment, or perhaps even logical points on the network such as interfaces.  Most importantly, these are points at which transmission providers need rating values to operate against.  

Rating snapshots are always done against Transmission Facilities.  Transmission Facilities include one or more Segments.  The Transmission Facilities included in TROLIE are typically pre-coordinated ahead of time, often through a modeling process.  

## Segments
Segments represent a component of some Transmission Facility that may affect its overall rating.  All Transmission Facilities must have at least one Segment.  In terms of TROLIE, ratings providers are obligated to provide rating data, in the form of Proposals, against segments.  On jointly owned lines or tie lines for example, each stakeholder in the line (the Transmission Facility) will be responsible for submitting Proposals against a different Segment in the model allocated to that stakeholder.  

## Proposals 
Proposals are forecasted or real-time ratings values submitted to TROLIE against a particular Segment.  They are referred to as "Proposals", as they are inputs to the limit "clearing" process internal to TROLIE server implementations that will integrate them into a final in-use rating set.  In-use limit Snapshots are a distinct data set from Proposals.  Proposals may be queried as well as submitted, so that the rating provider's original input data is always kept separately from the in-use ratings.  

## Snapshots
As implied above, Snapshots are generated in TROLIE server implementations based on proposals and other inputs to generate in-use ratings for each Transmission Facility.  TROLIE allows for ratings providers to fetch the latest snapshot, aka the latest "version" of the ratings data.  

## Monitoring Sets

Monitoring Sets are named sets of power system objects that may be used to
filter ratings and limits returned by queries against these APIs. How Monitoring
Sets are defined is beyond the scope of the TROLIE specification, and it is
assumed that the sender and receiver have predefined the appropriate Monitoring
Sets.

A typical implementation might define a Monitoring Set for each Ratings
Provider, containing all of the power system objects of interest to that Rating
Provider, such as their owned and/or operated facilities as well as any
additional objects whose limits they might monitor. It is generally assumed that
the Ratings Provider's Monitoring Set would include all of the transmission
facilities or other power system objects for which they have a Ratings
Obligation as well as their so-called "tier 1" monitored elements.

Another typical Monitoring Set would be that which nominates the complete
footprint for the Transmission Provider. A natural choice for the
`monitoring-set` identifier is the NERC id of the entity that defines the
`monitoring-set`, if applicable.
