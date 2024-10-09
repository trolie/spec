---
title: FAQ
---

# Frequently Asked Questions

### How are ambient conditions handled?

Ratings Proposals can include the ambient conditions that were used to determine
the ratings within the `inputs-used` attribute of `period`. These are also
returned in the `proposals-considered` of a detailed limits snapshot, e.g., the
`application/vnd.trolie.forecast-limits-detailed-snapshot.v1+json` [media
type](./articles/media-types.md).

### How is day/night handled?

Currently, the exchange of tables that map ambient conditions to ratings is not
in TROLIE scope.

Ratings Providers MAY specify day/night information as described in [above](#how-are-ambient-conditions-handled).

Seasonal Ratings in the API have an affordance to specify daytime versus
night-time ratings: Each "season" (a `period` in TROLIE) may populate an
optional `day-night` attribute. See the spec for details.
