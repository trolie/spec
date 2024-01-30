---
title: TROLIE Concepts
nav_order: 2
---

# TROLIE Concepts

Before reviewing examples, users may benefit from a basic understanding of the key constructs used by the TROLIE APIs.  Definitions of these concepts are included here.  

## Transmission Providers
Transmission Providers refers roughly to the FERC definition of "Transmission Provider" as any public utility that owns, operates, or controls facilities used for the transmission of electric energy in interstate commerce.  This could be said to apply to any entity that operates the transmission grid, including ISOs.  

For the purpose of TROLIE, Transmission Provider may be assumed to be more generic- it is really any entity that can receive ratings.  The Transmission Provider is the host of TROLIE server implementations.  

## Ratings Providers
A Ratings Provider is defined by this specification to be any entity that has pre-coordinated with the Transmission Provider hosting TROLIE to be the entity responsible for providing AARs on some set of Transmission Facilities.  Ratings Providers implement clients to TROLIE servers.  

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
Monitoring Sets are arbitrarily defined sets of transmission facilities that may be used to filter ratings and limits returned by queries against these APIs.  Defining the contents of these monitoring sets may vary, and is up to TROLIE server implementations.  
