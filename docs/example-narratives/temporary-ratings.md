---
title: Temporary Ratings
parent: Usage Examples
nav_order: 7
toc: true
---

# Temporary Ratings
FERC Order 881 includes a provision that allows grid operators
to temporarily set aside AARs to address immediate threats to reliability by 
[temporarily using an alternate static rating](https://www.federalregister.gov/d/2021-27735/p-71) for a facility.  These temporary ratings used 
must be documented and stored in a database, accessible for 5 years.  

TROLIE includes two kinds of temporary ratings objects:

* **Temporary AAR Exceptions** are exceptions to the ratings methodology on facilities using AARs. These are records that include a time-bound set of static ratings against a particular resource, with a free-text explanation as to why the exception occurred.  This typically relates to an outage or other physical need to "de-rate" a line.  
* **Seasonal Overrides** are used for updating seasonal ratings out-of-band of a Transmission Provider's typical seasonal rating update schedule and process.  Their structure is identical to Temporary AAR Exceptions.  However, the use cases are quite different, and generally only apply to certain corner cases.  Examples include:
  * For resources that are AAR-exempt and only support seasonal ratings, the seasonal override serves a similar purpose to Temporary AAR Exceptions.  
  * Resources at Transmission Provider seams may have seasonal ratings updated at offset schedules.  Seasonal Overrides provide a tool to handle these offsets in operational systems.  
  * If for any reason it makes sense to temporarily update the recourse rating for a given resource.  

## Creating Temporary Ratings
Temporary ratings, whether they be Temporary AAR Exceptions or Seasonal Overrides, are created in 
much the same manner.  The following `input.json` example could be used to create either a 
Temporary AAR Exception or Seasonal Override either by invoking 
[createTemporaryAARException](../spec#tag/Temporary%20AAR%20Exceptions/operation/createTemporaryAARException)
or 
[createSeasonalOverride](../spec#tag/Seasonal%20Overrides/operation/createSeasonalOverride)
respectively:

```json
{% include_relative examples/temporary-aar-exception-post.json %}
```

Note that the structures for origin, the associated power system resources and its aliases, 
as well as the rating values themselves all follow similar patterns and usages to AAR 
proposal submissions.  

### Creating a Temporary AAR Exception with `curl`

Given the above `input.json`, run the following command to send it to the TROLIE server:

```bash
curl -d @input.json \
-X POST \
-H "Content-Type: application/vnd.trolie.temporary-aar-exception.v1+json" \
-H "Accept: application/vnd.trolie.temporary-aar-exception.v1+json" \
-o output.json \
"https://trolie.example.com/temporary-aar-exceptions"
```

If this submission is successful, `output.json` will contain the contents of the
response from TROLIE. This response is identical to the input, except that the TROLIE
server will have assigned an ID to the exception.  An example of this response format 
is given below:

```json
{% include_relative examples/temporary-aar-exception-get.json %}
```

## Updating and Deleting Temporary Ratings
Once created, the temporary ratings may be updated.  This is often needed if the 
anticipated end time changes, or if more detail needs to be added to the
reason.  For the Temporary AAR Exception created above, this may be achieved by 
invoking [updateTemporaryAARException](../spec#tag/Temporary%20AAR%20Exceptions/operation/updateTemporaryAARException).  

Assuming the `output.json` file above was modified as desired, the Temporary
AAR Exception may be updated with the following command.  Note that the ID
returned from the create operation must be used in the URL:

```bash
curl -d @output.json \
-X PUT \
-H "Content-Type: application/vnd.trolie.temporary-aar-exception.v1+json" \
-H "Accept: application/vnd.trolie.temporary-aar-exception.v1+json" \
"https://trolie.example.com/temporary-aar-exceptions/46f7212b-1633-4c30-ba71-c6e987b2ded7"
```

Finally, the temporary rating may also have been created by mistake.  It may be 
canceled by deleting it using 
[deleteTemporaryAARException](../spec#tag/Temporary%20AAR%20Exceptions/operation/deleteTemporaryAARException)
This can be done with the following command:

```bash
curl 
-X DELETE \
"https://trolie.example.com/temporary-aar-exceptions/46f7212b-1633-4c30-ba71-c6e987b2ded7"
```

## Searching for Temporary Ratings
Temporary ratings that have been submitted to TROLIE may be searched, using either
[getTemporaryAARExceptions](../spec#tag/Temporary%20AAR%20Exceptions/operation/getTemporaryAARExceptions)
or 
[getSeasonalOverrides](../spec#tag/Seasonal%20Overrides/operation/getSeasonalOverrides).  These 
queries may be filtered with query parameters, including start/end time windows,
monitoring sets and individual resources.  

The following example command queries Temporary AAR Exceptions starting from 7/11 to 7/20, for any 
resource within `my-monitoring-set`:


```bash
curl \
-H "Accept: application/vnd.trolie.temporary-aar-exception-set.v1+json" \
-o output.json \
"https://trolie.example.com/temporary-aar-exceptions?monitoring-set=my-monitoring-set&period-start=2025-07-11T00:00:00-07:00&period-env=2025-07-20T00:00:00-07:00"
```

The resulting `output.json` file could then look like the following:

```json
{% include_relative examples/temporary-aar-exception-list.json %}
```