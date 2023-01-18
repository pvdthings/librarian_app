# Librarian app

## Background

[PVD Things](https://www.pvdthings.coop) is a non-profit & cooperative tool-lending library based in Providence, RI.

Tool libraries like PVD Things need some mission-critical apps to operate efficiently. Apps for things like:

- **Lending**
- Inventory
- Memberships
- Communications
- Money Management

## Problem

The current PVD Things librarian app built with Airtable Interfaces is functional, but with a steep learning curve. And most importantly, Airtable Interfaces is very limited in its set of features.

PVD Things needs a bespoke lending app that incorporates standardized lending policies and a user interface that is intuitive.

## Proposal

We will build a custom Librarian app for PVD Things. It will eventually be composed of many modules for managing all aspects of the cooperative, but it will begin with a mission-critical **lending module**.

The Lending module of the Librarian app will be inspired by the Airtable Interface it replaces, while addressing the pain-points brought up by Sarah and team.

The experience of using the app should be natural and require little to no instruction.

The long(er)-term goal is to transition away from Airtable and to Supabase, which is less costly to run and provides advanced authentication features. We will accomplish this by introducing Supabase behind our existing API, so that the client app can read from Supabase. _The new Librarian app will initially talk to Airtable through the existing API._

`Flutter app -> API -> Airtable`

Additional modules will follow, depending on priority.

### Timeline

Perhaps a reasonable deadline for the "make-it-work" stage of the app is **April 1, 2023**. (TBD)

We need to balance volunteer developer capacity and the org's capacity to continue functioning with its existing tools. As the frequency of lending increases, this app will become more needed.
