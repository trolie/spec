---
title: Forecast Submittal
parent: Usage Examples
nav_order: 1
toc: true
---


{: .nb }
This article assume some familiarity with HTTP in general and RESTful
APIs in particular ([background](../articles/trolie-for-ems-and-ot)).


### Quick Links
{:.no_toc}

* toc
{:toc}



## Simplified Example: Transmission Owner Sends Forecast with `curl`

If a Transmission Owner is their own Ratings Provider, they must regularly
regularly (at least hourly) send an Ratings Forecast to their Transmission
Provider. TROLIE provides the
[patchRatingForecastProposal](../spec#tag/Rating-Proposals/operation/patchRatingForecastProposal)
operation for this purpose.


Assume the Transmission Owner creates a file called `input.json` containing
their forecast. An example of the required format for the file is given below. The format is
one of TROLIE's [supported media types](../articles/supported-media-types)
named `application/vnd.trolie.rating-forecast-proposal.v1+json`.


```json
{% include_relative examples/forecast-ratings-proposal-patch.json %}
```

(This example also illustrates handling the fall Daylight Savings transition
in the Central timezone.)

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

If this submission is successful, `output.json` will contain a the contents of
the response from TROLIE. The format of the response is defined by another
TROLIE media type:
`application/vnd.trolie.rating-forecast-proposal-status.v1+json`. An example of
this response format is given below:

```json
{% include_relative examples/forecast-ratings-proposal-status.json %}
```

### Pushing `input.json` to TROLIE with `curl`
{:.no_toc}

