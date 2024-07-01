---
title: Querying in-use Real-Time Limits
parent: Usage Examples
nav_order: 4
---

# Ratings Provider Querying in-use Real-Time Limits from the Transmission Provider

Assuming a MonitoringSet "my-monitoring-set" that contains TransmissionFacilities of interest, then the current in-use real-time limits may be fetched with the following command:

```bash
curl -H "Accept: application/vnd.trolie.realtime-limits-slim-snapshot.v1+json" \
-o output.json \
"https://trolie.example.com/limits/realtime-snapshot?monitoring-set=my-monitoring-set"
```

This will return the current version of the in-use real-time limits into output.json.  
This data should include *all* limits in-use by the Transmission Provider, whether 
they were submitted through TROLIE, through ICCP, or derived by the Transmission Provider 
through some other means.  See the following for an example:

```json
{% include_relative examples/realtime-limit-set-slim.json %}
```

**NOTE**: This query is an example of an HTTP GET.  In addition to curl, the same URL may also be placed in a web browser to see the data.  

## Conditional GETs

While this example is appropriate for learning the API and trial usage, real applications 
will likely need to query these limits quite frequently.  Clients should use the pattern
for "conditional" GETs described in this [article](../articles/conditional-GET).   
