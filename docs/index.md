---
title: Home
nav_order: 1
---


<img alt="TROLIE logo" src="https://artwork.lfenergy.org/projects/trolie/icon/color/TROLIE-icon-color.svg" width="200" style="float:right"/>

# {{site.data.openapi-split.info.title}}


<a href="https://lfenergy.org/projects/trolie/">
  <img alt="Official LF Energy Project logo" src="https://artwork.lfenergy.org/other/lf-energy-project/horizontal/color/lf-energy-project-horizontal-color.png" width="200" />
</a>

For general announcements and discussion, subscribe to our [Email List <i class="fa-solid fa-envelope"></i>](https://lists.lfenergy.org/g/trolie-general).

***

{: .announcement }

> **Latest Updates** <i class="fa-solid fa-bullhorn"></i>
>
> * [Q&A](community-events/20240221-Intro-to-TROLIE#q--a) from the Intro to TROLIE webinar
> * An article on [Conditional GET](articles/conditional-GET.md) and how to use it to obtain snapshots efficiently
> * [How Units are Handled](articles/how-units-are-handled.md) to accommodate different practices by Reliability Coordinators
> * A concise description of [Forecast Windows](articles/forecast-windows.md) and how late forecast submissions are handled
> * A decision record on [Network Element Names and Naming Authorities](decision-log/naming)


# Introduction

With FERC Order 881, North American Transmission Owners, Transmission Operators, Transmission Providers, and Reliability Coordinators must establish a means to exchange ratings information based on current and forecasted ambient conditions. There is no standards body with a mandate to define a technical specification for that exchange and no vendor consortium that is working toward a specification.

TROLIE started as a [MISO](https://www.misoenergy.org/) and [GE Vernova](https://www.gevernova.com/) collaboration and is now an [LF Energy project](https://lfenergy.org/projects/trolie/). Most organizations involved in the operation of the transmission system in North America now need to exchange ratings and related information in an automated, frequent manner. This project will help accelerate their implementation and simplify interoperability.

The project’s specific aims are:

* <i class="fa-solid fa-hammer"></i> In Progress: Define an API specification for the exchange of ratings and ratings-related information to support organizations working to comply with FERC Order 881.
* <i class="fa-solid fa-calendar-check"></i> TODO: A conformance program to provide vendors a means to demonstrate their compatibility with the above specification and signal their commitment to maintaining compatibility.
* <i class="fa-solid fa-calendar-check"></i> TODO: An open commons for the development of clients of the API specification.


We are committed establishing a vendor-neutral specification and building an inclusive community.


[intro_webinar]: ./community-events/20240221-Intro-to-TROLIE