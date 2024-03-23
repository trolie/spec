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
[patchRatingForecastProposal](../spec#tag/Rating-Proposals/operation/patchRatingForecastProposal)
operation for this purpose.


Assume the Transmission Owner creates a file called `input.json` containing
their forecast. An example of the required format for the file is given below.

```json
{% include_relative examples/forecast-ratings-proposal-patch.json %}
```

This example also illustrates handling the fall Daylight Savings transition in
the Central timezone. The format is one of TROLIE's [supported media
types](../articles/supported-media-types) named
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

Additional client errors are identified in the [patchRatingForecastProposal spec](../spec#tag/Rating-Proposals/operation/patchRatingForecastProposal).

### Clients Should Check the `incomplete-obligation-count`
{:.no_toc}

The flip-side of this accommodative approach is that clients will not receive an
error response when one of their resource forecasts is invalid, so the spec
defines `incomplete-obligation-count`:

> {{ site.data.components.schemas["array-max-monitored-elements"].forecast-proposal-status.properties.incomplete-obligation-count.description }}

## Multiple Submissions per Forecast Window

{{ site.data.paths["rating-proposals_forecasts"].patch.description }}

## Jointly-Owned Facilities

In a jointly-owned facility there may be one or more Ratings Providers for a
given facility. This is expected to be fairly typical on seams. From a submittal
perspective, this is inconsequential: Each Ratings Provider simply submits their
own Forecast Proposal for Ratings Obligation using the appropriate
`resource-id`. As with all `resource-id` uses, the TROLIE spec is agnostic as to
which kind of Power System Resource is nominated by the identifier, but it will
typically be a Segment in the case of a Jointly-Owned Facility with multiple
Ratings Providers.
