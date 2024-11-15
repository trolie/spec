---
title: Using Slim Media Types
parent: Usage Examples
nav_order: 8
toc: true
---

The "slim" media types provided by TROLIE include:

* `application/vnd.trolie.rating-realtime-proposal-slim.v1+json`
* `application/vnd.trolie.seasonal-ratings-proposal-slim.v1+json`
* `application/vnd.trolie.rating-forecast-proposal-slim.v1+json`
* `application/vnd.trolie.forecast-limits-snapshot-slim.v1+json`
* `application/vnd.trolie.realtime-limits-snapshot-slim.v1+json`

These slim snapshots and proposals require the `limit-type` media type parameter
to be specified. The following names are valid values for the `limit-type`
parameter.
  
  * `active-power`
  * `active-power-with-power-factor`
  * `apparent-power`
  * `current`
  * `current-with-kV`
  * `reactive-power`
  * `overvoltage-threshold-pu`
  * `overvoltage-threshold`
  * `undervoltage-threshold-pu`
  * `undervoltage-threshold`

These correspond to the valid [Limit Types](../spec-1.0#tag/limit-type).

Here's an example that requests a slim forecast limits snapshot
```http
GET /limits/forecast-snapshot HTTP/1.1
Accept: application/vnd.trolie.forecast-limits-snapshot-slim.v1+json; limit-type=apparent-power
```



 This
"slim" format is much more space-efficient but requires a few processing steps
and assumptions:

1. The `limit-type` used in the proposal is specified by the Ratings Provider as
a parameter of the media type. The `limit-type` chosen determines the layout of
the ratings values.
2. The ratings are provided in order of decreasing duration, e.g., continuous
then emergency then load shed.
3. The facilities are required to be in the same order they appear in the
header.
4. The seasons are required to be in the same order they appear in the header.
5. Each forecast must have the number of hourly forecasts corresponding to the
new header field hours with the assumption that the begins header is the first
entry and each subsequent entry represents the subsequent hour's forecast.

This is discussed in further detail in the
[spec](../spec-1.0#schema/seasonal-proposals-slim). Here we can breakdown a concrete
example. We'll start with a `curl` request, then discuss the HTTP request itself
in two parts, the headers then the JSON payload.

##### `curl` Example
{: .no_toc }

```sh
curl -X PATCH \
     -H "Content-Type: application/vnd.trolie.seasonal-ratings-proposal-slim.v1+json; limit-type=apparent-power" \
     -H "Accept: application/vnd.trolie.seasonal-ratings-proposal-status.v1+json, */*" \
     -d @seasonal-ratings.json \
     $TROLIE_SERVER_URL/ratings-proposals/seasonal
```

{: .important }
> The `limit-type` parameter in the `Content-Type` header (line 2 above) is
> required by the TROLIE specification for the
> `application/vnd.trolie.seasonal-ratings-proposal-slim.v1+json` media type, as
> no default `limit-type` can be assumed. See [Limit
> Types](../spec-1.0#tag/limit-type) for the other options defined in the spec.

{: .nb }
> The `Accept` header in this example specifies one of the 
> [Status Responses](#status-responses).

##### HTTP Headers
{: .no_toc }

The previous `curl` request would result in an HTTP request like the following:

```http
PATCH /ratings-proposals/seasonal HTTP/1.1
Host: trolie.example.com
Accept: application/vnd.trolie.seasonal-ratings-proposal-status.v1+json, */*
Content-Type: application/vnd.trolie.seasonal-ratings-proposal-slim.v1+json; limit-type=apparent-power
```

##### Payload
{: .no_toc }

{: .important }
> For illustrative purposes here, we present the JSON payload with inline
> comments.  However, comments are **not** permitted in the TROLIE media types.

```jsonc
{
  "proposal-header": {
    "source": { /* ...details elided for clarity... */ },
    "default-emergency-durations": [
      { "name": "emergency", "duration-minutes": 240 },
      { "name": "load shed", "duration-minutes": 15  }
    ],
    "power-system-resources": [
      { "resource-id": "8badf00d",
        "alternate-identifiers": [ { "name": "segmentX", "authority": "TO-NERC-ID" } ]
      }, {
        "resource-id": "f34d3d",
        "alternate-identifiers": [ { "name": "segmentY", "authority": "TO-NERC-ID" } ]
      }
    ],
    "default-seasonal-schedule": {
      "schedule": [
        { "season-name": "WINTER", "begins": "2024-11-15T00:00:00-05:00" },
        { "season-name": "SPRING", "begins": "2025-03-01T00:00:00-05:00" },
        { "season-name": "SUMMER", "begins": "2025-06-15T00:00:00-05:00" },
        { "season-name": "FALL",   "begins": "2025-09-01T00:00:00-05:00" }
      ],
      "ends": "2025-11-15T00:00:00-05:00"
    }
  },
  "ratings": [
    // note all values are assumed to be MVA because the header in this example
    // Content-Type: application/vnd.trolie.seasonal-ratings-proposal-slim.v1+json; limit-type=apparent-power
    // specifies the apparent-power limit type which has a single value of MVA
    // see https://trolie.energy/spec-1.0#tag/limit-type

    [ // resource-id: 8badf00d
      [ // season-name: WINTER
        160, //continuous MVA
        170, //emergency MVA
        200, //load shed MVA
      ],
      [ // season-name: SPRING
        155, //continuous MVA
        160, //emergency MVA
        200  //load shed MVA
      ],
      [ // season-name: SUMMER
        145, //continuous MVA
        150, //emergency MVA
        200  //load shed MVA
      ],
      [ // season-name: FALL
        155, //continuous MVA
        160, //emergency MVA
        200  //load shed MVA
      ]
    ],
    [ // resource-id: f34d3d
      [ // season-name: WINTER
        161, //continuous MVA
        171, //emergency MVA
        201  //load shed MVA
      ],
      [ // season-name: SPRING
        156, //continuous MVA
        161, //emergency MVA
        201  //load shed MVA
      ],
      [ // season-name: SUMMER
        146, //continuous MVA
        151, //emergency MVA
        201  //load shed MVA
      ],
      [ // season-name: FALL
        156, //continuous MVA
        161, //emergency MVA
        201  //load shed MVA
      ]
    ]
  ]
}
```
