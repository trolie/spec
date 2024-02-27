---
title: Introduction to TROLIE webinar
parent: Community Events
---

# Summary

On February 21, 2024 the maintainers conducted a webinar hosted by LF Energy to
introduce the project to the broader community. The replay page is [here][recap].

<iframe width="560" height="315" src="https://www.youtube.com/embed/RRXwD8nyokc?si=qtT_ofwjmpGJITX6" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## By the Numbers

* RSVPs: 209
* Participants: 144
* Questions asked: 14

The audience posed some great questions, **thank you**! We didn't have time to
get to most of them, so we're answering them here. In some cases we've edited
the original question for clarity, based on our reading of them.

# Q & A

### Does the TROLIE interface handle day/night ratings?

No.  The use of day vs night ratings, as required by the FERC order, 
applies to the use of temperature-to-rating lookup tables to derive forecast ratings.  However, the current TROLIE design assumes that the entity computing the ratings has included the day vs night assumption into the numbers submitted for forecast ratings via https://trolie.energy/spec#tag/Rating-Proposals/operation/patchRatingForecastProposalForProvider.  This allows for other methodologies to be used, and also allows the ratings provider, if
desired, to make their own determination as to when day and night switch.  

There are multiple ways to interpret this question that could imply
useful extensions to TROLIE:

1.  Is it important to track whether the rating provided is based on a 
    day or night rating?  Is this a common use case for interop?
2.  Currently, the exchange of temperature-to-rating tables is not in TROLIE scope.  Should it be?
    Is this a common enough interop need?  

Please submit further questions, or propose TROLIE scope changes at https://github.com/trolie/spec/issues.

### How does CIM relate to the TROLIE Specification?

The maintainers are familiar with CIM, and it has influenced the development of
[TROLIE Concepts](https://trolie.energy/concepts). However, not all TROLIE
Concepts had an acceptable analogue in CIM and the traditional toolchain and
serialization conventions of CIM, e.g., RDF XML, do not align well with the
typical technology stack of a modern REST API. In short, TROLIE borrows what is
most useful from CIM's semantics while specifying a very conventional web API
using JSON media types.


<h3>Branches in our system model are nominated by a "From Bus" and a
"To Bus"; they are not assigned a (synthetic) unique identifier. How will we
be using the `resource-id` field to identify a branch when branches are not
assigned a single identifier?</h3>

We created a new issue for this: [#54](https://github.com/trolie/spec/issues/54).
Please join the discussion there.

<h3> How are Monitoring Sets, Transmission Facilities and Segments defined and
updated by Ratings Provider? What are the validation rules? How are they
coordinated with network model updates</h3>

TROLIE is intentionally agnostic to how server and client implementations update 
their network models, or whether these data entities are part of the network model 
at all, or updated via some other means.  The validation rules provided are also 
up to individual implementations.  

We understand that this is may be disappointing, because maintenance of 
network model databases and orchestrating their roll out can be
challenging, especially across entities.  

Exchanging model data is _not_ in the scope of TROLIE.  This is an incredibly
complex problem that likely requires its own set of defined protocols, standards, 
discussions and vendor adoption, much like the 
Common Grid Model Exchange Standard (CGMES) used in the 
ENTSO-E (https://www.entsoe.eu/data/cim/cim-for-grid-models-exchange/). 

As of this writing, the processes to update, exchange and orchestrate network model
updates in North America are highly fragmented.  TROLIE does not attempt to solve this problem.  

However, instead, we recognize this fragmented landscape as a reality that users of TROLIE must 
navigate.  In the short term, please consult appropriate vendors, reliability coordinators
or partners on how their specific software behaves.  In addition, we have created issue
https://github.com/trolie/spec/issues/57 to document recommended validation rules and model
coordination best-practices for TROLIE implementers.  

### Would TROLIE be a cloud-based solution?

TROLIE is agnostic to where servers are hosted.  The specification will work whether clients or
servers are hosted either on-premise or in a public cloud.  

Specific vendor products and reliability coordinator implementations will of course be more opinionated.  

### Does the specification allow for UTC timestamps?

Yes.  TROLIE timestamps use the RFC 3339 format (https://www.rfc-editor.org/rfc/rfc3339).  
This format is daylight savings-safe, as shown by example at https://trolie.energy/daylight-savings.  

The example referenced above however shows timestamps in local time zones.  The common way to specify UTC is
to use a "Z" character instead of a UTC offset as a suffix, like in the following example, which evaluates to 7am EDT:

    2025-11-01T11:00:00Z


<h3>How are the status/state of Real-Time and Forecast snapshots communicated
via TROLIE interfaces? How can we know from the TROLIE interface that a new
update for the snapshot values is available?</h3>

including the restriction of the TROLIE Specification to classic REST patterns
and HTTP/1.1. Thus, we don't specify WebSockets, Server Sent Events, or
recommend HTTP long-polling, instead relying on the [Conditional GET
pattern](https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests)
mediated by rate limiting.

We've created an issue to document using this pattern with TROLIE; see [issue
#56](https://github.com/trolie/spec/issues/56).


### Can you provide an implementation timeline? Is there an environment for us to test?

The TROLIE Specification is currently a WIP, and we are working on defining
[milestones](https://github.com/trolie/spec/milestones) for 1.0. Among these
milestones will be comprehensive examples.  However, since the TROLIE project
*does not intend* to develop a server implementation, we refer you to the
appropriate Reliability Coordinator for more information about integration
testing.

### Our RTO will need to send annual day/night times so each member uses the exact time to define day/night; can TROLIE support that?

This is currently out of scope of TROLIE.  As of now, TROLIE does not include anything
related to weather data.  Whether these timestamps represent weather data that should come from 
somewhere else, or they are truly key in orchestrating ratings exchange across providers in a common way is an interesting debate.  

If this is desired in TROLIE, the need should probably be driven by the RTO by 
reaching out to one of the project contributors, 
their vendor, and/or submitting a proposal to https://github.com/trolie/spec/issues.

### Does TROLIE handle the exchange of AARs between a Ratings Provider (TOP) using amps and an Clearinghouse Provider (RC) using MVA?

The TROLIE supports the exchange of various kinds of ratings, including apparent
power, current, reactive power, etc., so it supports specifying quantities with
the appropriate units, including amps and MVA. However, the specification does
*not* require the RC to accept any particular kind of rating, so the Ratings
Provider and the Clearinghouse Provider will need to pre-determine the
appropriate units. The TROLIE Specification is designed to be flexible enough to
accommodate most anticipated situations, such an RC only allowing for apparent
power as inputs and sending apparent power as outputs, as well as an RC allowing
for current and power factor as inputs. We have a [number of tasks
identified](https://github.com/trolie/spec/issues/43) to properly document this
feature. 

[recap]: https://community.linuxfoundation.org/events/details/lfhq-lf-energy-presents-webinar-introduction-to-trolie