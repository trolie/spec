---
title: Conditional GET
parent: Articles
---

# Conditional GET

TROLIE implementations MUST support the Conditional GET pattern and clients
should use it to determine when limits snapshots are available. While this
pattern is [well-documented by
Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests),
it can be helpful see a concrete example. In this article we will discuss this
pattern in the context of obtaining a Forecast Limits Snapshot.

By employing the Conditional GET pattern, the client can efficiently determine
when a new version of the resource is available without having to repeatedly
download the entire resource during polling. This helps in reducing unnecessary
network traffic and conserving bandwidth.

This pattern involves using the HTTP `GET` method along with conditional headers
such as `If-None-Match` and `If-Modified-Since` to check if the resource located
at `/limits/forecast-snapshot` has been modified since the last request.

Let's start with this initial request:

```http
GET /limits/forecast-snapshot HTTP/1.1
Host: trolie.example.com
User-Agent: TROLIE-Examples-Client
Accept: application/vnd.trolie.forecast-limits-snapshot.v1+json
Accept-Encoding: br
```

Suppose this is the response from the TROLIE server:

```http
HTTP/1.1 200 OK
Content-Type: application/vnd.trolie.forecast-limits-snapshot.v1+json
Server: trolie.example.com
Date: Wed, 29 Feb 2024 12:00:00 GMT
ETag: "d41d8cd98f00b204e9800998ecf8427e"
X-Rate-Limit-Limit: 100
X-Rate-Limit-Remaining: 98
X-Rate-Limit-Reset: 3600

{... response body in Brotli compressed format ...}
```

When using the Conditional GET pattern, the client includes the previously
received `ETag` and/or `Last-Modified` timestamp in the request headers. If the
resource has not been modified since the provided `ETag` or `Last-Modified`
timestamp, the server responds with a `304 Not Modified` status code, indicating
that the client's cached version is still valid. If the resource has been
modified, the server responds with a 200 OK status code and provides the updated
resource.

The TROLIE client can then issue a Conditional GET:

```http
GET /limits/forecast-snapshot HTTP/1.1
Host: trolie.example.com
User-Agent: TROLIE-Examples-Client
Accept: application/vnd.trolie.forecast-limits-snapshot.v1+json
Accept-Encoding: br
If-None-Match: "d41d8cd98f00b204e9800998ecf8427e"
```

Assuming a new snapshot hasn't been generated, we should see a response similar
to the following:

```http
HTTP/1.1 304 Not Modified
ETag: "d41d8cd98f00b204e9800998ecf8427e"
Server: trolie.example.com
Date: Wed, 29 Feb 2024 12:03:20 GMT
X-Rate-Limit-Limit: 100
X-Rate-Limit-Remaining: 97
X-Rate-Limit-Reset: 3400
```

{: .nb }

> <i class="fa-solid fa-triangle-exclamation"></i> **Note**:
> The `X-Rate-Limit-Remaining` is decremented here, since
> rate limiting is applied in all circumstances, including
> 3XX and 4XX responses.

*Otherwise*, we would have gotten a new limit forecast:

```http
HTTP/1.1 200 OK
Content-Type: application/vnd.trolie.forecast-limits-snapshot.v1+json
Server: trolie.example.com
Date: Wed, 29 Feb 2024 12:03:20 GMT
ETag: "123e4567e89b12d3a456426614174000"
X-Rate-Limit-Limit: 100
X-Rate-Limit-Remaining: 97
X-Rate-Limit-Reset: 3400
Content-Encoding: br

{... response body in Brotli compressed format ...}
```


### Note to Implementors

The use of `If-None-Match` with `ETag` headers is strongly encouraged to
implement the Conditional GET pattern. The `ETag` should *not* be a simple
hash of a particular representation of a resource, i.e., do not compute
a hash of the JSON document returned to the client. Instead the `ETag` should
be unique to the logical state of the resource. One method to do that is
illustrated in this pseudocode:

```
ETag: hash("{resource internal id}+{last modified timestamp}")
```

This has several desirable properties for an `ETag`:
* Unique: Minimizing the chance of collisions for different resources.
* Opaque: Clients cannot infer anything about the resource content or structure from the ETag.
* Stable: Changes only when the the resource is updated.