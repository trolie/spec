---
title: Performance Trade-offs in the TROLIE Schema Design
parent: Articles
---

{: .nb }
> At the time of the this article, only the Forecast portion of the
> TROLIE 1.0 specification is considered stable. However, the design choices made
> for Forecasts are anticipated to be used in RT and Seasonal as well.

# Performance Trade-offs in the TROLIE Schema Design

## Introduction

Initial feedback from the broader electric power industry community is that the
JSON format that TROLIE currently specifies is going to be inefficient. Some are
concerned that if they adopted that schema, they wouldn't be able to meet their
performance objectives, given the volume of ratings submissions they will be
handling.

The goals of this article are:

* Discussing the relative priority of certain quality attributes in the TROLIE
  project

* Addressing the rationale for the current schema specification

* Mitigating performance concerns of implementors

## Quality Attribute Priorities

TROLIE primarily exists to foster interoperability between systems that need to
exchange ratings and limits in order to comply with FERC Order 881. Accordingly,
the project prioritizes qualities that enhance interoperability and security
over other qualities attributes related to performance efficiency.

Attributes like clarity, compatibility/flexibility, debuggability, auditability,
and [robustness](https://en.wikipedia.org/wiki/Robustness_principle) promote
interoperability, yet these attributes are often in tension with performance
efficiency. Consideration of these attributes led to the choice of boring,
long-established technologies--JSON, HTTP, OpenAPI--to specify TROLIE. Security
concerns like auditability and non-repudiation have also informed the schema
design.

## Schema Design Rationale

The entire schema for [Forecast
Proposals](https://trolie.energy/spec#tag/Forecasting/operation/patchRatingForecastProposal)
is certain worth scrutinizing, but for our immediate purposes, let's dilate on
just the `ratings` object of the message.

```json
{
  "proposal-header": { /* details elided for clarity */ },
  "ratings": [
    {
      "resource-id": "8badf00d",
      "periods": [
        {
          "period-start": "2025-11-01T01:00:00-05:00",
          "period-end": "2025-11-01T02:00:00-05:00",
          "continuous-operating-limit": {
            "mva": 160
          },
          "emergency-operating-limits": [
            {
              "duration-name": "lte",
              "limit": {
                "mva": 165
              }
            },
            {
              "duration-name": "ste",
              "limit": {
                "mva": 170
              }
            },
            {
              "duration-name": "dal",
              "limit": {
                "mva": 170
              }
            }
          ]
        } // other periods elided for clarity
      ]
    } // other resource forecasts elided for clarity
  ]
}
```

There are a few considerations to call out here:

* _Does not assume that rating applies to a single hour._ While that
 is a fine assumption to make for most if not all current Order 881
 implementations, the current TROLIE approach allows for flexibility in how the
 interval for a given rating is applied. Since this approach is used in Forecast
 and RT Ratings Proposals as well as the Limits Snapshots, implementors benefit
 from uniformity in API. (Exchange of DLRs may become necessary
 [soon](https://www.ferc.gov/news-events/news/sunshine-notice-june-2024-commission-meeting).)

* _Does not assume emergency rating durations._ Not all entities utilize the
  same emergency durations, and while a given TO to RC exchange might be able to
  make this assumption, an interop standard has to be compatible with all RCs.

* _Does not assume units for ratings._ Not all entities utilize the same units
  for specifying limits, of course. The TROLIE schema allows for different units
  to be used with different power system resources in the same forecast.

## Mitigating Performance Concerns

Still, the performance concerns are real. This article is not an attempt to 
discredit them. Let's address the one's we've heard.

### Concern 1: Transferred Bytes

JSON is a *terrible* choice from a
performance perspective, but it is also ubiquitous and will be so for decades to
come. It also has a decent schema language that OpenAPI builds upon.

Certainly, though, a more compact way to represent the data we need to exchange,
even in bloated JSON, is possible. However, JSON compresses *extremely* well,
and much of the data in the proposed format is repeated, like the timestamps
required for each period. Gzip is perhaps more ubiquitous than JSON, and the
widely implemented Brotli is incredibly efficient at compressing JSON.

Moreover, the semantics of PATCH (used to submit proposals) allow a Ratings
Provider to break up their submissions into multiple requests if they chose to
employ that as a tactic to ensure robustness of the exchange, i.e., to support
smaller payloads that are faster to retry.

### Concern 2: Processing Efficiency

There are some obvious performance considerations when implementing any exchange
that has to support 881, because

> 240 hours &times; multiple emergency durations &times; a large footprint = a lot of ratings to process.

#### Don't Read It All Into Memory

Implementors are strongly encourages to use a streaming or event-based
("SAX-style" for you XML aficionados) parser when reading submissions. This
advice would likely apply in a general way, even given a ratings exchange
specification that made different trade-off decisions. TROLIE specifies a
`proposal-header` that afford the server the opportunity to make some processing
decisions early, without waiting to receive the last byte.

#### Ignore What You Don't Need

Also, implementors are encouraged to *ignore what you don't need*. For example,
it is definitely the case that most submissions will have 240 periods. While the
TROLIE schema requires `period-start` and `period-end` timestamps for each one,
if you are in a position to dictate conventions for the exchange, you could
ignore these and require a submission always include 240 sequential hourly
period forecasts; doing so would not violate the TROLIE schema, and you would
still have an unambiguous record of the intended use of the rating if it comes
to non-repudiation or debugging.

## Interop is a Conversation

The Maintainers believe the current schema for Forecast Proposals and Forecast
Limits Snapshot strikes a good balance between performance and fostering
interoperability, but nothing speaks louder than data. To that end we hope to
update this post soon with actual code and performance data, but if you need to
make a go/no-go decision about TROLIE today, and this is the issue holding you
back, please don't let it. The schema is not written in stone and better ideas
are always welcome.
