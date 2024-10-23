---
title: Limit Provenance
parent: Articles
---

# Limit Provenance
{:.no_toc}

{: .nb }
How did the [Clearinghouse](../concepts.md#clearinghouse-provider) determine a
limit for a given period?

To answer this question, we have to be aware of the inputs that were available.
For any given period for a particular facility, these may include:

* Operator overrides
* Any [Temporary AAR Exceptions](../concepts.md#temporary-aar-exception)
  applicable during that period
* One or more [Segment Ratings](../concepts.md#segments) that were provided for
  that period by a [Ratings Provider](../concepts.md#ratings-provider)
* Any applicable [Seasonal overrides](../concepts.md#seasonal-overrides) and/or
  [Seasonal Ratings](../concepts.md#seasonal-ratings), such as when the
  Transmission Owner is exempt from providing AARs for the particular facility.

Taken together, we refer to this information as the provenance of the limit.

### Quick Links
{:.no_toc}

* toc
{:toc}

## How TROLIE Represents Provenance
{:.no_toc}

Whether you are obtaining a [Real-Time](../spec#tag/Real-Time/operation/getRealTimeLimits)
or [Forecast Limits Snapshot](../spec#tag/Forecasting/operation/getLimitsForecastSnapshot),
TROLIE specifies a detailed [media type](./media-types.md) that contains provenance information;
these are
* `application/vnd.trolie.realtime-limits-detailed-snapshot.v1+json` and
* `application/vnd.trolie.forecast-limits-detailed-snapshot.v1+json`, respectively.

The schema for provenance information is effectively shared between these media
types.  Here's what the provenance information looks like at a high level for a
given period:

```jsonc
{ // note that other fields have been elided for clarity
  "proposals-considered": [],
  "temporary-aar-exceptions": [],
  "overrides": []
}
```

Note there's no explicit indication that a particular proposal's continuous
rating set the continuous limit or that a proposal's emergency duration rating
was used for the emergency limit. However, this can be reconstructed by
examining the inputs, i.e., `proposals-considered`, `overrides`, and
`temporary-aar-exceptions`.  Let's explore these three fields, starting with
`proposals-considered`.

### Proposals Considered

The `proposals-considered` array is so-named in reference to [ratings
proposals](../concepts.md#ratings-proposals). Recall that the clearinghouse
determines a limit by examining the ratings available for a given period. Rating
Provider's propose ratings for a given period to the Clearinghouse.

Here's an example of a `proposals-considered` entry when there is only one
Ratings Provider for the facility.

```jsonc
{ // several fields elided for clarity
  "proposals-considered":[
  {
      "resource-id": "8badf00d-UTILITY-A-SEG-id", // logical segment id
      "source":{
        "last-updated": "2025-07-12T14:10:12-07:00",
        "provider": "UTILITY-A",
        "origin-id": "8badf00d-UTILITY-A-correlation-id" // from original ratings proposal message
      },
      "proposal-disposition": "Used",
      "continuous-operating-limit": { "mva": 150 },
      "emergency-operating-limits": [
          { "duration-name": "emergency",
            "limit": { "mva": 165 }
          }
      ]
  }]
}
```

Observe that there is a `resource-id` attribute of a `proposals-considered`
entry.  This may seem redundant given that there is a `resource-id` associated
with the limit itself which contains the `proposals-considered` array. However,
as the example intimates, the Ratings Provider (in this case "UTILITY-A") may
have provided a rating for just one (logical) segment of the overall
transmission facility. Therefore `proposals-consider[0].resource-id` may not be
the same identifier as the `resource-id` of the limit itself. On the other hand,
if `proposals-consider[0].resource-id` is not provided, then it is assumed to be
the same as the limit itself.


{: .nb }
**Note**: TROLIE supports facility ratings for situations where a given Ratings
Provider may have multiple [Ratings Obligations](../concepts.md#ratings-obligation)
for a given power system resource. See [Conditional Ratings](../decision-log/conditional-ratings.md) and
[Directional Ratings](../decision-log/directional-ratings.md).

Similarly, the `source` object refers to the original Ratings Proposal message that contained
this proposal. This is exactly the same information as is contained by `proposal-header.source`
when submitting a [forecast](../spec#tag/Forecasting/operation/patchRatingForecastProposal)
or [real-time proposal](../spec#tag/Real-Time/operation/postRealTimeProposal).

Next we have `proposal-disposition`. This field is an enumeration of two values:
`Used` or `Rejected`. In context, this means either this proposal was
"Considered but Rejected" and so not eligible to be used by the clearinghouse
(presumably it was invalid) **or** it was used by the clearinghouse, though
crucially it may not have been the most limiting rating, so did not set the
limit.

Finally, we have the original ratings, i.e., the limits that were proposed. If
these were most limiting, they might be reflected in the limit determined by the
clearinghouse.

#### Scenario: Multiple Ratings Providers

There may be multiple ratings proposals for a given power system resource. This
is anticipated to be the case on [RC-RC interties](./RC-to-RC-reconciliation.md)
for example, where the proposals would come from multiple Ratings Providers.
Another scenario called out above is when a given Ratings Provider has multiple
Ratings Obligations for given facility.

In either case, the provenance has the same structure. There's more than one
entry in `proposals-considered` for a given limit. Let's seen an example:

```jsonc
{ // several fields elided for clarity
  "proposals-considered":[
    { "resource-id": "8badf00d-UTILITY-A-SEG-id",
      "source":{
        "provider": "UTILITY-A",
        "origin-id": "8badf00d-UTILITY-A-correlation-id"
      },
      "proposal-disposition": "Used",
      "continuous-operating-limit": { "mva": 150 }
    },{ "resource-id": "8badf00d-UTILITY-B-SEG-id",
      "source":{
        "provider": "UTILITY-B",
        "origin-id": "8badf00d-UTILITY-B-correlation-id"
      },
      "proposal-disposition": "Used",
      "continuous-operating-limit": { "mva": 140 }
    }
]}
```

This is a simple case. Without looking at any other provenance information for
this period, we might expect that UTILITY-B had the most limiting continuous
rating. Another scenario should round out our understanding of `proposals-considered`.

#### Scenario: Rejected Proposal

It's possible that the Clearinghouse Provider initially accepted an
[on-time proposal](./forecast-windows.md#on-time--202-accepted) but ultimately rejected
it during clearing. This is indicated by `proposals-consider[].proposal-disposition = "Rejected"`.

#### Scenario: Transmission Provider Proposes a Recourse Rating

In certain situations, a Transmission Provider may be obliged to propose a
[recourse rating](../concepts.md#recourse-ratings) to satisfy a given Ratings Provider's 
Ratings Obligation.

```jsonc
{ // several fields elided for clarity
  "proposals-considered":[
    { "resource-id": "8badf00d-UTILITY-A-SEG-id", // same as above
      "source":{ // but the source is different
        "provider": "ISO-A",
        "origin-id": "8badf00d-ISO-A-correlation-id"
      },
      "proposal-disposition": "Used",
      "continuous-operating-limit": { "mva": 110 }
    }
]}
```

Note that the `source` is now the Transmission Provider, i.e., ISO A, and not
the owner of the Ratings Obligation associated with `8badf00d-UTILITY-A-SEG-id`,
i.e., UTILITY A. This will typically be a seasonal rating.

### Temporary AAR Exceptions

However, other circumstances may result in a different static rating being used.
Such is the case with [Temporary AAR Exceptions](../concepts.md#temporary-aar-exception).

```jsonc
{ // fields have been elided for clarity
  "proposals-considered": [],
  "temporary-aar-exceptions": [
    {
      "id": "https://trolie.example.com/temporary-aar-exceptions/1234",
      "start-time": "2025-07-12T16:00:00-07:00",
      "end-time": "2025-08-01T00:00:00-07:00", // optional
      "continuous-operating-limit": { "mva": 160 },
      "emergency-operating-limits": [ /* emergency limits elided */],
      "source": { // optional
        "origin-id": "2d8c80e8-f533-4be9-85bf-f7f81eb73d67",
        "provider": "UTILITY-A",
        "last-updated": "2025-07-12T16:00:00-07:00"
      },
      "resource": { // optional
        "resource-id": "8badf00d-UTILITY-A-SEG", // segment
        "alternate-identifiers": [ /* if present, must have at least one entry */]
      }
    }
  ],
  "overrides": []
}
```

The presence of an entry in `temporary-aar-exceptions` indicates that there was
an active temporary AAR exception for that period. Note that only the `id`,
`start-time`, and the limit values are required. The `end-time` is optional to
accommodate situations where an estimate for an outage resolution is
unavailable. The `source` property (if provided) would indicate what upstream
system originally created the exception, and the `resource` property serves the
same function as `resource-id` in `proposals-considered`, i.e., it nominates the
underlying power system resource that has the exception if it is not the overall
facility.

### Operator Overrides

Similar to Temporary AAR Exception, the presence of a value here indicates that
an override was in place for the given period.

```jsonc
{ // fields have been elided for clarity
  "proposals-considered": [],
  "temporary-aar-exceptions": [],
  "overrides": [
    {
      "continuous-operating-limit": {
        "mva": 160
      },
      "emergency-operating-limits": [ /* elided for clarity */ ],
      "override-reason": "TOI 20250701-01",
      "start-time": "2025-07-12T16:00:00-07:00",
      "end-time":   "2025-09-12T16:00:00-07:00", // optional
      "id": "ems-operator-override-id-1", // optional
      "resource": { "resource-id": "8badf00d-UTILITY-A-SEG" }, // optional
      "source": { // optional
        "last-updated": "2025-07-12T14:10:12-07:00",
        "provider": "ISO-A",
        "origin-id": "8badf00d-ISO-A-outage-id"
      }
    }
  ]
}
```

Typically only a single override would be present if at all, but it's possible
that a jointly-owned facility might have concurrent overrides on multiple
segments, for example. Most of the provenance information for the override is
optional; the primary use case for that info is debugging and troubleshooting.
