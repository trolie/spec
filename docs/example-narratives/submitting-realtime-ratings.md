---
title: Real-Time Rating Submittal
parent: Usage Examples
nav_order: 5
toc: true
---


This article assumes some familiarity with HTTP in general and RESTful
APIs in particular ([background](../articles/trolie-for-ems-and-ot)).  It also 
follows very similar patterns to the concepts for forecast ratings, so the examples
on [forecast](submitting-forecasts) ratings may be helpful for background.  



## Simplified Example: Transmission Owner Sends Ratings with `curl`

If a Transmission Owner is their own Ratings Provider, they must regularly send
real-time ratings to their Transmission Provider. TROLIE provides the
[postRealTimeProposal](../spec#tag/Rating-Proposals/operation/postRealTimeProposal)
operation for this purpose.


Assume the Transmission Owner creates a file called `input.json` containing
their ratings measurements. An example of the required format for the file is given below.

```json
{% include_relative examples/realtime-proposal.json %}
```

The format is one of TROLIE's supported media types named
`application/vnd.trolie.rating-realtime-proposal.v1+json`.


### Pushing `input.json` to TROLIE with `curl`

Given the above `input.json`, run the following command to send it to the TROLIE server:

```bash
curl -d @input.json \
-X POST \
-H "Content-Type: application/vnd.rating-realtime-proposal.v1+json" \
-H "Accept: application/vnd.trolie.rating-realtime-proposal-status.v1+json"
-o output.json \
"https://trolie.example.com/rating-proposals/real-time"
```

If this submission is successful, `output.json` will contain the contents of the
response from TROLIE. The format of the response is defined by another TROLIE
media type: `application/vnd.trolie.rating-realtime-proposal-status.v1+json`. An
example of this response format is given below:

```json
{% include_relative examples/realtime-proposal-status-complete.json %}
```

## Invalid Ratings for Individual Resources Should be Tolerated

The TROLIE spec supports allowing some individual ratings to be
invalid without rejecting the entire proposal, much like with forecasts.  
The pattern for incomplete and invalid proposals is similar to the 
one described for forecasts illustrated in [Forecast Submittal](submitting-forecasts).

### `incomplete-obligation-count` as a Monitoring Function

The use of the proposal status in realtime will differ somewhat from the usage
with forecast ratings.  The forecast obligation always applies to a particular 
window.  Real-Time ratings, in contrast, are always simply updated against the current time.
The real-time Clearinghouse may run more frequently than once an hour, and
rating proposals may be run even more, or less frequently than the Clearinghouse.

In addition to flagging data that is missing, the `incomplete-obligation-count` 
also flags data that is considered too "stale" to use.  The definition
of what is considered stale is ultimately up to the Clearinghouse 
implementation.  If supported by the Clearinghouse, `incomplete-obligation-count` 
may also consider obligations for resources that would normally not have 
their ratings submitted as TROLIE proposals, but rather through other means, such as ICCP.  

Therefore, clients should rely more on asynchronous use of 
[getRealTimeProposalStatus](../spec#tag/Rating-Proposals/operation/getRealTimeProposalStatus)
as a way to monitor whether the Clearinghouse considers their ongoing data stream
healthy.  

## Jointly-Owned Facilities

In a jointly-owned facility there may be one or more Ratings Providers for a
given facility. This is expected to be fairly typical on seams. The pattern is 
nearly identical to the way this works for forecasts, with the exception that the 
Clearinghouse may run much more frequently.  From a submittal
perspective, this is inconsequential: Each Ratings Provider simply submits their
own Ratings Proposal for their Ratings Obligation using the appropriate
`resource-id`. As with all `resource-id` uses, the TROLIE spec is agnostic as to
which kind of Power System Resource is nominated by the identifier, but it will
typically be a Segment in the case of a Jointly-Owned Facility with multiple
Ratings Providers.
