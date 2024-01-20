---
title: Querying in-use Limit Forecast
parent: Usage Examples
nav_order: 2

---




# Ratings Provider Querying in-use Limit Forecast from the Transmission Provider

Assuming a MonitoringSet "my-monitoring-set" that contains TransmissionFacilities of interest, then the current in-use forecasted limits may be fetched with the following command:

```bash
curl -H "Accept: application/vnd.trolie.forecast-limit-set-slim.v1+json" \
-o output.json \
"https://trolie.transmission-provider.com/rating-proposals/forecasts?monitoring-set=my-monitoring-set"
```

This will return the current version of the in-use ratings for the next 240 hours into output.json.  See the following for an example:

### Reuse JSON method 1:

 {% capture example %}
 {{- site.data.paths["limits_forecast-snapshot"].get.responses["200"].content["application/vnd.trolie.forecast-limit-set-slim.v1+json"].example["$ref"] 
    | split: "/" | last
 -}}
 {% endcapture %}

{% assign example_json = '_data/examples/' | append: example %}

```json
{% include_relative {{example_json}} %}
```

### Method 2:

```json
{% include_relative _data/examples/forecast-limits-slim.json %}
```

The above example assumes the next 240 hours as determined by the computer clock where TROLIE server is running.  Given that there are edge cases in time and the user’s clocks are likely slightly off from the TROLIE server's clock, it is recommended to specify the times more explicitly to ensure that users are getting what is expected.  This may be done by specifying the "offset-period-start" parameter, like in the following example:

```
https://trolie.transmission-provider.com/rating-proposals/forecasts?monitoring-set=my-monitoring-set&offset-period-start=2025-11-02T02:00:00-06:00
```

**NOTE**: This query is an example of an HTTP GET.  In addition to curl, the same URL may also be placed in a web browser to see the data.  
