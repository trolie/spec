---
title: Why REST and OpenAPI?
nav_order: 2
---

# Why REST and OpenAPI?

While REST isn’t new.  It was first published in [academic literature in the year 2000](https://ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm).  

However, it may imply a learning curve for typical operations technology (OT) teams 
that need to integrate with TROLIE.  This is because EMS systems are the most common integration targets for TROLIE, where 
older methods have frequently been used for data exchanges, such as SCADA protocols, 
custom TCP-based protocols, and ad-hoc file exchanges.   

TROLIE is built on the philosophy that this is an acceptable tradeoff due to the upside that 
REST offers over these traditional data exchange methods.  An entire paper could be written purely on this subject as to the benefits 
of using REST for this sort of complex data exchange.  To summarize:
*	REST is significantly easier to secure than either SCADA protocols or file-based exchanges.  This aligns well to modern cyber-security architectures, but also provides several security benefits and architectural flexibility to transmission providers.  It is ultimately a transmission provider's decision whether to run the API directly over the public internet or over 
dedicated channel such as a VPN or frame relay.  Nothing in REST requires a dedicated channel.  
* Data integrity and non-repudiation is much easier to achieve with REST, especially vs file exchanges.  
*	REST has established patterns for modeling complex data structures that would be awkward in SCADA-style exchanges like ICCP.  
*	REST has established patterns for making backward compatibility significantly easier than it would be for file exchanges without developing complex custom conventions.  
*	It will be significantly easier to scale the system in terms of both load and performance with REST than it would be with the more traditional exchange methods used in EMS.  

While there are many good materials available for understanding the REST architecture in detail, users of the TROLIE APIs do not need to be experts in REST.  From a user perspective, REST could be seen as a minor cognitive leap from file exchanges, which this document will illustrate through examples.  

## Why not ICCP?
The Inter-Control Center Communications Protocol (ICCP), part of IEC standard 60870-6, is used freqently to integrate reliability coordinators' SCADA system with member transmission owners' SCADA systems to capture all kinds of telemetry data from the power grid.  It has traditionally been used for dynamic line ratings / real-time AARs for selected lines as an emerging technology.  ICCP works well for this use case, as the rating of the line in real-time is functionally much like any other telemetry.  
ICCP is reliable, mature, and well-known, and will continue to be supported by many transmission providers as a method for submitting real-time ratings.  Even though TROLIE supports real-time rating exchange, continued use of ICCP for real-time ratings is compatible with the use of TROLIE.  However, ICCP won’t scale well to handle the forecasted data.  There are a couple reasons for this:
*	The data model is a significant mismatch.  ICCP is designed around SCADA concepts, such as points and quality flags.  It is difficult to create arbitrarily complex data structures, like a coordinated forecast, and link them together.  There are also needs to provide various strings into this data, such as override reasons.  
* Using ICCP for forecasts would result in a significant increase in the count of SCADA points.  Across our customer base, GE sees increased pressure on SCADA systems due to other changes to the power grid.  The increased configuration overhead and load on potentially overtaxed SCADA systems makes ICCP less attractive.  

This is all in addition to considering the advantages of REST discussed above.  

## Why not File Exchanges?  
Unlike ICCP, file exchanges using common formats such as CSV, XML, and JSON do allow for more complex data structures.  The advantages to REST however over file exchanges are all outlined above.  In addition to these more abstract advantages, the authors of TROLIE see a trend across the utility industry where file exchanges are becoming a common source of failure and management expense for backing infrastructure / IT teams.  File exchanges, especially over networks, imply the use of high-end shared storage devices.  These devices are complex to maintain, secure, and operate redundantly across data centers, and we've seen in practice are a common source of many of the application failures utilities and other grid operators see in production.  

## REST is a Document Exchange Over the Web
To understand this API, REST could simply be seen as the exchange of JSON "files" over HTTP (or more precisely for production environments, HTTPS).  TROLIE API implementers host a server, which may be accessed over the HTTPS port (443).  As a user, one sends a JSON document to a URL, much like a website.  This act of sending, called a "request", includes the following:
*	A URL, much like one would enter a web browser to visit a website.  This URL determines the operation of the API being invoked, as well as identifying information for the resource being edited.  The URL may also include query parameters.  
*	A set of headers.  These are key-value pairs that also provide metadata about the request.  
*	A "method" to be used against the resource.  Methods are a built-in part of the HTTP protocol, and the typical standard methods are used by the TROLIE API.  These include:
    - **GET** fetches a resource.  **GET**s are generally queries.  
    - **HEAD** only fetches HTTP response headers associated with a resource one would otherwise **GET**.  This is for more advanced usage, often associated with caching.  **HEAD** requests may be used to determine whether data returned by **GET** has changed without calling **GET**.
    - **POST** is used to create a new resource.
    - **PUT** is used to update a resource.  
    - **PATCH** is used to partially update a resource.  This is like **PUT** but implies that users don’t have to provide the whole document.  Rather, the JSON document would include only the changes.  
    - **DELETE**, intuitively, deletes a resource.  
*	A JSON document to be used as input, referred to as a request "body".   This is only applicable for **POST**, **PUT** and **PATCH** requests.  

In return, the server will respond back with a response.  The response includes:
* A numeric status code, indicating success or failure of the request.  TROLIE uses standard HTTP status codes.  
* A set of response headers.  These are key-value pairs providing metadata of the response, much like the request headers.  
*	A JSON document, referred to as a response “body”, including either the data requested, or a list of errors or warnings.  Not all operations return bodies.  **HEAD** requests, for example, never return bodies on success.  

While toolkits are available in most modern languages for executing these requests in a high-performance way in-memory, it may be convenient for users to learn the API through file exchange.  This is possible using the free open-source tool [Curl](https://curl.se/).  Curl is a command-line tool that may be used to interact with REST APIs, including TROLIE, entirely using files.  Curl is included with most Linux distributions as well as MacOS.  It may be freely downloaded for Windows from the Curl website linked above.  The examples of usage in [Usage Examples](usage-examples.html) are done entirely using Curl.  

## OpenAPI
In practice, modern REST APIs are documented using OpenAPI specifications.  These specifications dictate the operations that are available in the API, along expected parameters, headers, response codes, and JSON schema for requests and responses.  This also includes documentation and descriptions of schema, operations, and parameters.  OpenAPI specifications are specified in files, formatted using either YAML or JSON.  TROLIE provides an OpenAPI specification using YAML, the more easily human-readable format.  

Many tools are available to work with OpenAPI, both commercial and open source.  A good reference may be found at [here](https://openapi.tools/).  Libraries are available to work with REST and OpenAPI in most programming languages grid operators are familiar with, including Python, Java, C#/.NET and others.  The TROLIE project recommends ratings providers use these tools to integrate their systems with TROLIE.  

As mentioned above, it is also possible to simply work with files using curl and similar utilities.  This is recommended to be used primarily for testing and exploration purposes.  Likewise, it is possible to invoke the GET operations of the API simply by putting the appropriate URLs in a web browser.  