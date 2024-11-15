---
title: Versioning through Media Types
parent: Decision Records
---

## Status

* Status: `committed`

## Context

The primary mandate of the TROLIE project is defined by its
[Scope](https://github.com/trolie/spec/tree/HEAD/Scope.md).  Paramount to
meeting that mandate is defining the [TROLIE 1.0 API
specification](https://trolie.energy/spec), yet this is a [community
specification](https://github.com/trolie/spec/blob/1.0.0-wip/Community_Specification_License.md)
and supporting the implementation and testing efforts of the community will
inevitably identify deficiencies and gaps in the 1.0 spec.

The necessity of freezing the specification is self-evident, but it bears
mentioning that implementors need an independent reference to develop against
and to mediate interop debugging.

Therefore, the TROLIE project needs a versioning strategy, a plan for updating
the specification after the `1.0.0` version is declared, that is, after the spec
is published as `1.0.0`. "Versioning" in this context is the method by which a
web API exposes updated functionality to clients. Typical methods of versioning
a web API include:

* URL versioning where new or updated functionality is accessible by using a
  different URL.
* Parameter-driven versioning where a header or query parameters are provided by
  the client to make use of new or updated functionality.
* Configuration-driven versioning where the version of the API provided to the
  client is determined by out-of-band configuration on the server.
* Media type versioning where the schemas and semantics of individual request
  and response messages have versions associated.

Today, [SemVer](https://semver.org/) is used ubiquitously to nominate
iterations in the functionality exposed by software, including web APIs. In particular,
the `major.minor.patch` semantics of SemVer are essentially:
* `major` increments imply breaking changes
* `minor` increments imply non-breaking changes that add functionality
* `patch` increments imply bug fixes that are non-breaking changes

As an Open API specification, the difference between breaking and non-breaking
changes come down to the syntax and semantics of the operations defined by the
TROLIE spec.

TROLIE 1.0 is a two-sided contract: Some are implementing clients for
use by Ratings Providers; some are implementing server for use by Clearinghouse
Providers; and some are implementing both, such as in
Clearinghouse-to-Clearinghouse communications. Accordingly, we must understand
breaking changes from all these perspectives. It is anticipated that some TROLIE
implementations will partially adopt the TROLIE 1.0 specification. For
example, a vendor may only choose to implement the Forecasting operations, or
two adjacent Transmission Owners might choose to only share seasonal ratings.

Enabling this kind of a la carte use of the specification by the community is
desirable, and a [Conformance program](https://github.com/trolie/conformance) to
provide clarity on what is implemented by various vendors was part of the
project's original charter, with the goal of supporting incremental conformance; not every feature will be supported in every implementation, and incremental conformance is about ensuring that parts that are implemented have an unambiguous specification that can be verified with automated tests.

## Decision

The TROLIE 1.0 project will manage versioning at two levels: the operation
binding information and the valid request/response messages for those
operations. The binding information includes the HTTP verb, path, and query
parameters for each operation, whereas the project uses [media
types](../articles/media-types.md) to explicitly define the valid
request/response messages.

### Adopt SemVer

The overall TROLIE API version will follow SemVer. Operation binding information
changes will be assessed to determine their impact, and the TROLIE API version
will be updated accordingly. Note this decision is being made in the context of
the TROLIE 1.0 Working Group Scope, so there will be no breaking changes posited
once `1.0.0` is declared. Accordingly, no binding information will be removed or
renamed, and no request/response messages will have breaking changes.

In particular, none of operations defined under `1.0.0` will be removed, and any
additional operations or additional query parameters added to the existing
operations will result in a minor version change, e.g., `1.1.0`. However, there
will only be one valid TROLIE 1.0 specification; the publishing of `1.1.0` will
supersede and deprecate `1.0.0`. The intent with the minor update is to signal
to the community during the implementation and validation phase that additional
functionality has been specified.

### Media Type Versions
Media types will be versioned separately but will only have `major` versions.  Changes to media types that would constitute a `patch`
change under SemVer will not be recorded in the media type name itself. However,
every non-breaking change to a media type--both `minor` and `patch`--will be
considered a `patch` revision of the overall TROLIE 1.0 API, i.e., `1.0.0`
&rarr; `1.0.1`.

Note that `minor` revisions to a media type itself would include adding an
***optional*** property, whereas adding a required property would constitute a
breaking change from the server's perspective. Since the `patch` version of the
TROLIE 1.0 API will be updated with `minor` revisions to media types, there is
no need to version the media type name itself.

If a breaking change in a media type is necessary to satisfy the TROLIE 1.0
Scope, after `1.0.0` is declared, a new major version of that media type will be
nominated. Adding a new major version of a media type without removing the older
version is not a breaking change to the spec itself, since server implementors
may choose which operations they support. Thus, adding a new media type to the
TROLIE 1.0 API version would have a `minor` version increment, i.e., `1.0.1`
&rarr; `1.1.1`.


### "Bug Fixes" are a `patch`

There may be some breaking changes permitted during the implementation and
validation phase after `1.0.0` is declared. Development of the Conformance tests
are underway, and we anticipate the those tests and/or implementations have the
potential to clarify requirements that would be best be met by introducing a
breaking change. Since `1.0.0` signals that the Scope of the specification is
considered to be satisfied, we would consider breaking changes only for "bug
fixes".

For example, if a property is obviously required in an exchange, but it is not
formally required in the spec due to an error of omission, we would make it
required and increment the `patch` version, i.e., `1.1.1` &rarr; `1.1.2`.
Another example of a "bug fix" would be a spelling error or a property rename
that results in better uniformity without impacting semantics.  The logic here
is that these are bugs in the specification and implementations would not have
committed to that error. The point is the spec is meant to serve the
implementors, not the other way around; interop is the goal, not blind conformance.

This may seem like playing fast and loose with the prescribed SemVer versioning
strategy, but these bugs in the spec will be discovered as interop is achieved,
so these fixes will not be necessary once the implementation and validation
phase is complete.

## Consequences

Pervasive use of versioned media types allow for different representations to be
provided for the same resource. This allows the TROLIE 1.0 spec to be updated in
the future efforts without breaking existing implementations. It also supports
the Conformance program by providing granular delineation of the functionality
supported by different implementations, supporting incremental conformance.

When `1.0.0` is declared, a new branch called **1.0** will become the main branch of
[github.com/trolie/spec](https://github.com/trolie/spec), and the version number
of the spec itself will be updated to `1.0.0` in a commit that is tagged `1.0.0`.
Subsequent updates to the **1.0** branch will update the spec version and be
tagged accordingly.

If future maintainers should choose to depart from the versioning strategy in
this decision, they should create a new branch (e.g. **2.0**) or a new
repository entirely. Implementors of TROLIE 1.0 can be confident that the `HEAD`
of the **1.0** branch will be tagged with the API version that represents the
culmination of the project's scope.
