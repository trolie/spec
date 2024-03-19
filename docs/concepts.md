---
title: TROLIE Concepts
nav_order: 2
---

# TROLIE Primary Concepts
{:.no_toc}

Before reviewing examples, users may benefit from a basic understanding of the
key constructs used by the TROLIE API.

![UML concept model](<images/data model.excalidraw.png>)

### Quick Links
{:.no_toc}

* toc
{:toc}

Since TROLIE stands for _Transmission **Ratings** and **Operating
Limits** Information Exchange_, we start there.

## Operating Limit, or simply _Limit_

System Operating Limit is a well-defined industry term, but the salient point
for TROLIE is that a Limit satisfies the most limiting of any provided
reliability criteria. Limits for Transmission Facilities are determined by the
Clearinghouse after considering all Ratings Proposals for the Power System
Resources associated with that Transmission Facility during a particular Period
of an Operational Window.

## Rating

For TROLIE's purposes, a Rating is simply a **proposed** Limit for a Period of
an Operational Window from a Ratings Provider for a particular Power System
Resource.

## Power System Resource, or simply _Resource_

A term borrowed from CIM, in the context of TROLIE, a "Resource" is an object of
the exchange whose identity--the `resource-id`--and other details have been
pre-coordinated such that both parties can assign the ratings and/or limits
associated with the `resource-id` to a particular element in their network
model.

## Clearinghouse Provider

Clearinghouse Provider is how this specification refers to the entity that hosts
a TROLIE server for the purposes of collecting ratings from multiple Ratings
Providers for a large footprint in order to determine and disseminate Limits
Snapshots. Generally, this anticipated to be a Transmission Provider (FERC), such
as an ISO.

{: .nb }
> **A note on new terminology**
>
> "Clearinghouse Provider" along with "Ratings Provider" and "Ratings Obligation"
> are indeed terms introduced by TROLIE. Defining the specific roles in the
> exchange explicitly and using them ubiquitously is meant to reduce ambiguity
> and promote generality in the specification.

## Ratings Provider

A Ratings Provider is a role defined by this specification to be responsible for
a set of Ratings Obligations. Ratings Providers should typically implement
clients to interact with TROLIE servers to fulfill these obligations. In some
cases a Clearinghouse Provider might implement processes to obtain Ratings from
a Ratings Provider who does not implement a TROLIE client, submitting Ratings on
behalf of that Ratings Provider.


## Ratings Obligation

A Ratings Obligation is a pre-coordinated expectation to provide compliant
ratings for a given resource. Usually, this means providing forecast and
real-time AARs for that resource. Ratings Obligations are used to authorize
Ratings Proposals.

## Transmission Facilities

We refer the reader to the definitions provided by FERC and/or their
Transmission Provider's tariff, but it suffices here to understand a
Transmission Facility to be the power system resource that has its Limit
determined by the Clearinghouse. Typically, the Transmission Facility is a
transmission line or a transformer.

## Segments

For the purposes of the TROLIE specification, a Segment is a logical construct:
A power system resource Transmission Facilities may be comprised of one or more
Segments. A distinct Ratings Provider is assigned to each Segment. This modeling
is pre-coordinated and is out of scope for TROLIE, so while a Transmission
Facility is generally expected to have at least one Segment, the `resource-id`
of a Ratings Proposal might nominate a Transmission Facility in some
Clearinghouse implementations.

In terms of TROLIE, ratings providers are obligated to provide rating data, in
the form of Proposals, against segments. On jointly owned lines or tie lines for
example, each stakeholder in the line (the Transmission Facility) may be
responsible for submitting Ratings Proposals against a different Segment in the
model allocated to that stakeholder.


## Ratings Proposals

Proposals are forecasted or real-time ratings values submitted to TROLIE against
a particular Segment. They are referred to as "Proposals", as they are inputs
to the limit "clearing" process internal to TROLIE server implementations that
will integrate them into a final in-use rating set. In-use limit Snapshots are
a distinct data set from Proposals. Proposals may be queried as well as
submitted, so that the rating provider's original input data is always kept
separately from the in-use ratings.

## Limits Snapshots

As implied above, Snapshots are generated in TROLIE server implementations based
on proposals and other inputs to generate in-use ratings for each Transmission
Facility. TROLIE allows for ratings providers to fetch the latest snapshot, aka
the latest "version" of the ratings data.

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
