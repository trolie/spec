---
title: Versioning through Media Types
parent: Decision Records
---

## Status

* Status: `accepted`

## Context

The TROLIE project needs a plan for updating the specification after the
1.0 scope is complete, that is, after the spec is published as 1.0 and clients
and servers are deployed that are dependent on that version of the spec.

"Versioning" is the method by which a web API exposes updated functionality to
clients. Typical methods of versioning a web API include:

* URL versioning where new functionality is accessible by using a different URL
* Parameter-driven versioning where a header or query parameters a provided by the client to make use of new 
* Media type versioning

## Decision

We believe that versioning media types is the best way to extend the TROLIE
specification when new functionality is needed from the operations that are
specified for 1.0. New operations of course can be added that complement the
1.0 operations. New media type versions in either case will follow semver. 

## Consequences

Pervasive use of media types allow for different representations to be provided
for the same resource. This allows the spec to support anticipated use cases
requiring different information or performance characteristics. If new
representations are identified later, these can be added to the spec without
breaking existing clients.

We require versions in the media type names to ensure clients do not break as
servers evolve.
