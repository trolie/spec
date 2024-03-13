---
title: Directional Ratings
parent: Usage Examples
nav_order: 3
---

# Ratings Provider Submitting Directional Ratings to TROLIE
Most lines only require a single set of rating values that apply irregardless 
of the direction that energy is flowing. However, for a some lines, 
Transmission Providers may require separate "directional" ratings that 
differ depending on the direction energy is flowing.  

Directional ratings are supported in TROLIE by exposing separate 
resources, both in terms of `TransmissionFacilities` and `Segments`, to 
represent different rating directions.  The names used for these resources are 
ultimately up to the TROLIE implementation.  The following two examples show some 
contrasting styles for naming these resources.  Both are equally valid, and are 
provided here only as examples.  

## With "Named Direction"-Style Naming
One common style, such as that supported by the GE Vernova EMS, is to represent 
rating directions by specifying an arbitrary `in` and `out` direction on a line, 
typically representing the most common flow of energy in and out of a load pocket,
control area or other logical grouping of the transmission network.  
This is illustrated by the following forecast proposal example:

```json
{% include_relative examples/forecast-proposal-directional-named.json %}
```

## With "Point to Point"-Style Naming
An alternative style could be to name the resources as a concatenation
of the identifiers on each end, with the order of the identifiers indicating the
direction of the flow.  Consider two substation buses, with the very simple identifiers
`BusA` and `BusB`.  These are used to illustrate point-to-point naming in the following forecast
proposal example:

```json
{% include_relative examples/forecast-proposal-directional-point-to-point.json %}
```