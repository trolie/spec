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
get to most of them, so we're answering them here. In some cases we've taken the
liberty of editing the questions based on our reading of them in the webinar
Q&A.


# Q & A

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


<h3>How are the status/state of Real-Time and Forecast snapshots communicated
via TROLIE interfaces? How can we know from the TROLIE interface that a new
update for the snapshot values is available?</h3>

We've made an intentional decision to adopt the certain design constraints,
including the restriction of the TROLIE Specification to classic REST patterns
and HTTP/1.1. Thus, we don't specify WebSockets, Server Sent Events, or
recommend HTTP long-polling, instead relying on the [Conditional GET
pattern](https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests)
mediated by rate limiting.

We've created an issue to document using this pattern with TROLIE; see [issue
#56](https://github.com/trolie/spec/issues/56).





[recap]: https://community.linuxfoundation.org/events/details/lfhq-lf-energy-presents-webinar-introduction-to-trolie
