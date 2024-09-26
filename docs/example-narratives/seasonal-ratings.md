---
title: Seasonal Ratings
parent: Usage Examples
nav_order: 6
toc: true
---

{: .nb }
This article assumes some familiarity with HTTP in general and RESTful
APIs in particular ([background](../articles/trolie-for-ems-and-ot)).


### Scenario Quick Links
{:.no_toc}

* toc
{:toc}

## Simplified Example: Transmission Owner Sends Seasonal Ratings with `curl`

If a Transmission Owner is their own Ratings Provider, they must update their seasonal ratings
and send them to their transmission provider at least annually.  

TROLIE provides the
[patchSeasonalRatingsProposal](../spec#tag/Seasonal/operation/patchSeasonalRatingsProposal)
operation for this purpose.

**NOTE: Support for this function is an optional part of the TROLIE specification.  Transmission Owners / Rating Providers should check with their transmission provider for the method they specifically support for sending seasonal ratings to the transmission provider.**

Assume the Transmission Owner creates a file called `input.json` containing
their ratings. An example of the required format for the file is given below.

```json
{% include_relative examples/seasonal-ratings-proposals-patch.json %}
```

The format is one of TROLIE's supported media types named
`application/vnd.trolie.seasonal-rating-proposal.v1+json`.  This example illustrates
submission of a year's worth of seasons.  


### Pushing `input.json` to TROLIE with `curl`
{:.no_toc}

Given the above `input.json`, run the following command to send it to the TROLIE server:

```bash
curl -d @input.json \
-X PATCH \
-H "Content-Type: application/vnd.trolie.seasonal-rating-proposal.v1+json" \
-H "Accept: application/vnd.trolie.seasonal-ratings-proposal-status.v1+json"
-o output.json \
"https://trolie.example.com/rating-proposals/seasonal"
```

If this submission is successful, `output.json` will contain the contents of the
response from TROLIE. The format of the response is defined by another TROLIE
media type: `application/vnd.trolie.seasonal-ratings-proposal-status.v1+json`. An
example of this response format is given below:

```json
{% include_relative examples/seasonal-ratings-proposal-status.json %}
```

## Season Definitions and Names
The examples above refer to specific named seasons as assumed by the submitter.  `WINTER`,
for example, is shown to start on November 15th, ending on March 1st of the following year.  

In many existing OT systems, seasonal ratings are modeled as a simple lookup table, with
the name of each season as a key.  However, such representations aren't sufficient for TROLIE; the 
definitions of these seasons differ between all of TROLIE's various stakeholders, so the season names 
have no consistent meaning.  Instead, to support interop, the intended start and end times 
of each rating are specified.  The `season-name` field is only there to provide a hint as 
to the submitter's intent.  

It is ultimately up to the Transmission Provider and TROLIE server implementer as to the flexibility 
they will allow in seasonal ratings submissions relative to the Transmission Provider's season 
conventions used in operations.  The Transmission Provider may elect to be quite liberal, allowing
ratings providers to define their own seasons.  Alternatively, the TROLIE server may refuse to accept
submissions that don't match the Transmission Provider's pre-defined seasons exactly.  

Ratings Providers should check with specific Transmission Providers for rules and expectations for 
how seasonal ratings may be submitted.  

## Client Errors and Obligations

Client errors are handled in much the same way as with forecast ratings, as described in 
[Forecast Submittal](submitting-forecasts.md).  A submittal may have partial success, meaning that 
some resources are valid and the proposal for that resource will be saved.  A validation error for 
a resource implies that no data was saved for that resource.  

Obligations also work in a similar fashion as they do to forecasts.  However, rather than being targeted
at a particular forecast window, incomplete obligations should indicate ratings that have not been 
been submitted for seasons in the upcoming year as required by the FERC order.  

## Conditional or Configuration-Based Seasonal Ratings

Some underground or underwater lines have different ratings based on the line's configuration.  These 
lines include cables that are packed tightly together and may be turned on or off depending on 
configuration.  Since these lines are packed tightly together, they create a heating effect on one
another.  Therefore, the overall line may have very different ratings depending on the configuration.  

For AARs, it is typically assumed that the current configuration (or forecasted configuration) is 
accounted for in the AAR.  

However, for seasonal ratings, the configuration cannot be forecasted.  Therefore, separate seasonal
ratings must be provided for each allowed configuration combination of the line.  These are called
"conditional" ratings in ISO New England's footprint.  

The pattern for conditional seasonal ratings in LEP is similar to the way 
[directional ratings](directional-ratings.md) work.  Each possible configuration simply represents
a separate resource in TROLIE, as shown in the example proposal submission below:

```json
{% include_relative examples/seasonal-ratings-proposals-conditional.json %}
```