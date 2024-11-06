---
title: Forecast Submittal
parent: Usage Examples
nav_order: 1
toc: true
---


{: .nb }
This article assumes some familiarity with HTTP in general and RESTful
APIs in particular ([background](../articles/trolie-for-ems-and-ot)).


### Scenario Quick Links
{:.no_toc}

* toc
{:toc}



## Simplified Example: Transmission Owner Sends Forecast with `curl`

If a Transmission Owner is their own Ratings Provider, they must regularly send
a Ratings Forecast to their Transmission Provider. TROLIE provides the
[patchRatingForecastProposal](../spec#tag/Forecasting/operation/patchRatingForecastProposal)
operation for this purpose.


Assume the Transmission Owner creates a file called `input.json` containing
their forecast. An example of the required format for the file is given below.

```json
{% include_relative examples/forecast-ratings-proposal-patch.json %}
```

This example also illustrates handling the fall Daylight Savings transition in
the Central timezone. The format is one of TROLIE's supported media types named
`application/vnd.trolie.rating-forecast-proposal.v1+json`.


### Pushing `input.json` to TROLIE with `curl`
{:.no_toc}

Given the above `input.json`, run the following command to send it to the TROLIE server:

```bash
curl -d @input.json \
-X PATCH \
-H "Content-Type: application/vnd.trolie.rating-forecast-proposal.v1+json" \
-H "Accept: application/vnd.trolie.rating-forecast-proposal-status.v1+json"
-o output.json \
"https://trolie.example.com/rating-proposals/forecast"
```

If this submission is successful, `output.json` will contain the contents of the
response from TROLIE. The format of the response is defined by another TROLIE
media type: `application/vnd.trolie.rating-forecast-proposal-status.v1+json`. An
example of this response format is given below:

```json
{% include_relative examples/forecast-ratings-proposal-status-complete.json %}
```


## Invalid Forecasts for Individual Resources Should be Tolerated

The TROLIE spec supports allowing some individual resource forecasts to be
invalid without rejecting the entire proposal. A specific example will help
illustrate the idea. Suppose the Ratings Provider submits a Forecast Proposal
for two resources--`8badf00d` and `d34dc0d3`.  Further suppose that there's
nothing wrong at all with the `d34dc0d3` forecast, but the `8badf00d` forecast
is missing an hour, with everything else about the request being valid. In this
case TROLIE should a return response like the following:

```http
HTTP/1.1 202 Accepted
Content-Type: application/vnd.trolie.rating-forecast-proposal-status.v1+json
Server: trolie.example.com
Date: Wed, 29 Feb 2024 12:03:20 GMT
ETag: "123e4567e89b12d3a456426614174000"
X-Rate-Limit-Limit: 100
X-Rate-Limit-Remaining: 97
X-Rate-Limit-Reset: 3400


{% include_relative examples/forecast-ratings-proposal-status.json %}
```

### Client Errors are Not Acceptable
{:.no_toc}

Bear in mind the proposal must always be
[on-time](/articles/forecast-windows.html#on-time--202-accepted). Moreover,
there are other client errors that are not tolerated, including:

* Malformed requests, i.e., the JSON provided is not valid according to the
  media type schema.
* Unprocessable content error: when the Forecast Proposal is well-formed, but
  the [units provided in any of the forecasts are
  invalid](/articles/how-units-are-handled#validation).
* Unprocessable content error: when none of the individual resource Forecast
  Proposals are valid, but the request is otherwise well-formed.

Additional client errors are identified in the [patchRatingForecastProposal spec](../spec#tag/Forecasting/operation/patchRatingForecastProposal).

### Clients Should Check the `incomplete-obligation-count`
{:.no_toc}

The flip-side of this accommodative approach is that clients will not receive an
error response when one of their resource forecasts is invalid, so the spec
defines `incomplete-obligation-count`:

> The number of facilities for this provider whose Ratings Obligation has
> not been met in this forecast window. This number may be larger than the
> size of `incomplete-facilities`, since the latter has a pre-defined
> upper bound for performance and application security reasons.

> The Ratings Provider should check that this value is zero when they
> believe they have completed their submission process.

## Multiple Submissions per Forecast Window

In every Forecast Window, a new area-wide Forecast Proposal is created on
the TROLIE server of the Clearinghouse Provider. Each Ratings Provider then
`PATCH`es the area-wide proposal with the forecasts for their respective
Ratings Obligations. Any unmet Ratings Obligations will result in the
Clearinghouse Provider using an appropriate Recourse Rating for those unmet
obligations.

For Ratings Providers with a natural split in their Ratings Obligations,
e.g., geographic or control areas, the `PATCH` semantics afford the ability
to submit multiple Forecast Proposals containing just proposals for the
relevant resources, if they choose to do so. This affordance can also be
leveraged to split a large proposal into one or more parts in cases where
that is advantageous from a performance or reliable delivery perspective.

There are two supported media types for a Real-Time Ratings proposals.

`application/vnd.trolie.rating-forecast-proposal.v1+json` allows the 
Ratings Provider to combine different limit types, such as
`apparent-power` (MVA) and `current` (MW), in a single proposal.

`application/vnd.trolie.rating-forecast-proposal-slim.v1+json` for
proposals that only require a single limit type, e.g., `apparent-power`.
Clients *MUST* specify that [limit-type](#tag/limit-type) as a media type
parameter. For example,

```http
PATCH /ratings-proposals/forecast HTTP/1.1
Content-Type: application/vnd.trolie.rating-forecast-proposal-slim.v1+json; limit-type=apparent-power
```

Note that this format is much more concise but requires significant care in
serialization/deserialization.  For details, see [Using Slim Media
Types](../example-narratives/using-slim-media-types).


## Jointly-Owned Facilities

In a jointly-owned facility there may be one or more Ratings Providers for a
given facility. This is expected to be fairly typical on seams. From a submittal
perspective, this is inconsequential: Each Ratings Provider simply submits their
own Forecast Proposal for Ratings Obligation using the appropriate
`resource-id`. As with all `resource-id` uses, the TROLIE spec is agnostic as to
which kind of Power System Resource is nominated by the identifier, but it will
typically be a Segment in the case of a Jointly-Owned Facility with multiple
Ratings Providers.
