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

*TODO*

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

*TODO*

### Would TROLIE be a cloud-based solution?

*TODO*

### Does the specification allow for UTC timestamps?

*TODO*

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

*TODO*

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
