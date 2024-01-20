---
title: Daylight Savings
nav_order: 5
---

# Handling Daylight Savings Transitions in TROLIE

Daylight savings transitions are a notorious problem in software systems.  Specifically in data exchanges, data formats must contend with two challenges:

* Both transition days don't have 24 hours.  The Spring transition of course has 23, the Fall transition 25.  
* The day of the Fall transition has two unique hours that are both referred to in local clocks as "1 AM", one before and the other after the transition.  

The first problem (non-24 hour days) does not create any particular problem for the TROLIE data formats.  The second problem of the "duplicate hour" however is explicitly handled by the consistent use of the standard [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339) date time format.  This format assumes that the server can understand time universally, typically by using internal references in UTC.  In the API, RFC 3339 date times must include explicit operating time zone offsets from UTC.  Therefore, the difference between the "1 AM" hours is always visible in the timezone offset.  

For example, in central US time in 2025, the Fall transition day would begin with the following hours:

```
2025-11-02T00:00:00-05:00
2025-11-02T01:00:00-05:00
2025-11-02T01:00:00-06:00
2025-11-02T02:00:00-06:00
2025-11-02T03:00:00-06:00
```

Note that the two 01:00:00 times are uniquely distinguished with the -05:00 and -06:00 offsets.  