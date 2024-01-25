---
title: Usage Examples
nav_order: 4
has_children: true
---

# Usage Examples

These pages run through some simple examples of API usage for typical use cases,
using JSON snippets and [curl](https://curl.se/) commands.

## Caveats on Examples

The examples provided here have some limitations, as the real TROLIE server
implementations may differ in certain details:

* The actual URLs used for the TROLIE service themselves are only examples.

* Additional configuration will be necessary depending on the authentication
  strategy used. This is ultimately a platform capability of the Transmission
  Provider and/or vendor implementing the TROLIE server.

* The rating set tiers (normal, emergency, short-term emergency etc) used by
  each Transmission Provider differ, and TROLIE is designed to be agnostic to
  this. The rating names therefore used in these examples may not match
  exactly those in use by a particular TROLIE server.
