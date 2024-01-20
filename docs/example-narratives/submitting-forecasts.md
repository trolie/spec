---
title: Submitting Forecast Ratings
parent: Usage Examples
nav_order: 1
---

# Ratings Provider Submitting Forecast Ratings to the Transmission Provider

For most transmission owners (rating providers in TROLIE terminology), the most important operation will be to regularly (at least hourly) send forecasted AARs to SPP.  This is done by updating that TO’s forecasted rating Proposal.  More specifically, this may be achieved using the [patchRatingForecastProposal](../spec#tag/Rating-Proposals/operation/patchRatingForecastProposal) operation in TROLIE.  

For the purpose of this example, the JSON listing below may be assumed to be in a file called `input.json`.  The input consists of an array by segment, which then contains an array of ratings for each forecast period.  Note this example also cross the Fall daylight savings transition in the central timezone, thus providing an example of dealing with the notorious "duplicate" 1 AM hour:

```json
{
  "ratings": [
    { 
      "segment-id": "segmentX",
      "periods": [
        {
          "period-start": "2025-11-02T01:00:00-05:00",
          "values": [
            {
             "type": "normal",
             "value": {
               "mva": 160
             }
            },
            {
             "type": "emergency",
             "value": {
                "mva": 165
             }
            }
          ]
        },
        {
            "period-start": "2025-11-02T01:00:00-06:00",
            "values": [
              {
               "type": "normal",
               "value": {
                 "mva": 162
               }
              },
              {
               "type": "emergency",
               "value": {
                  "mva": 167
               }
              }
            ]
        }, 
        {
            "period-start": "2025-11-02T02:00:00-06:00",
            "values": [
              {
               "type": "normal",
               "value": {
                 "mva": 162
               }
              },
              {
               "type": "emergency",
               "value": {
                  "mva": 167
               }
              }
            ]
        }              
      ]
    }
  ]
}
```

## Pushing input.json to TROLIE
Given input.json, run the following command to send it to the TROLIE server:

```bash
curl -d @input.json \
-X PATCH \
-H "Content-Type: application/vnd.trolie.rating-forecast-proposal.v1+json" \
-o output.json \
"https://trolie.transmission-provider.com/rating-proposals/forecasts"
```

On success, output.json will container a copy of the data just uploaded, with additional metadata on update time and status.  