---
layout: post
title: Interim Project Proposal - Zagaku
date:   2017-10-16 12:00:00 -0500
categories: product
excerpt_separator: <!--more-->
---

For the upcoming individual interim project, I would like to propose a new internal tool for apprentice organizaiton.

# Zagaku, the app

![zagaku]({{ site.url }}/assets/zagaku1.png)

<!--more-->

### Goals

- Content
  - Central location for all Zagaku information
  - Aggregate statistics
  - Increase transparency for all parties
  - Increase lifetime of content produced for Zagakus
- Organization
  - Simple scheduling
  - Single button solicitation via slack
  - Automated booking set by parameters
- Statistics
  - Set imperitive topics
  - Rank imperitive topics by number of apprentices absent from each
  - Set paths / nessesary sphere of knowledge
  - Simple access / high visibility of past zagaku topics
  - Show trends based on subject / business area / language
  - Show trends of cancelled Zagakus?
- Archival
  - host as much content on github per zagaku (in case the app falls into disuse)
  - book lists
  - video lists
- Tracks
  - Tracks per knowledge domain / language / framework
  - Composed of book / document / webpage / series / video / podcast
  - Tracks are viewable in a grid of cards
  - Click to open modal for overview
  - Click to add to apprentice / crafter profile
  - Track can be clicked off as completed
  - Code snippets / github repo / blog can be added per item if they so choose

# Tracks

![zagaku2]({{ site.url }}/assets/zagaku2.png)

The goal of Tracks is to create an simple, intuitive path to sufficientcy in a given language, technology or framework.  These could be used to organize a quick onboarding path for long term clients, or for common technologies.  Somtimes it is difficult to locate appropriate resources to learn a particular subset of skills.

Tracks can have dependent Tracks.  For example, Phoenix would have a dependency on Elixir.  This would suggest the completion of the Elixir path to fully grasp the content of the Phoenix path.

# Zagaku Scheduling

![zagaku3]({{ site.url  }}/assets/zagaku3.png)

The goal of scheduling is multifold. The primary goal is broad transparency for all stake holders, enabling all parties to have a picture of Zagakus at a glance. The secondary goal is the liberation of the information produced for a Zagaku, both to reduce duplicated preparation and to enable a broader ingestion of the information, and to ensure persistence of generated content. The final goal is to streamline planning, scheduling and communication.

# Library - _somewhat aspirational_

The library feature will allow the scanning of ISBN numbers and input of volume numbers to a centralized system to enable tracking of books, show availabily of resources in track and zagaku notes, and to have a searchable and organizable catalog. This is highly dependent on third party code and APIs.

### Integrations

- Slack
  - Booking
  - Booking solicitation
  - Bot Stats
    - Upcoming schedule
    - Recent Topics / Upcoming Topics
    - Imperitive & absent topics based on apprentice
    - Time left in apprenticeship
    - Zagaku champions rank
  - Automated Booking on fallback
- Github
  - Content replication
  - Code gists
  - etc.
- OAuth
  - nessesary for calendar
  - one click login

# Random list of ideas (brain dump)


Mirror gCal functions (add, move, show, invite)

Past Zagaku and Zagaku History

Segmentation by topic, language, technology, stack location (back end, front end, etc)

Breakdown by Languages, Design, CS Fundamentals, Hardware, Consulting, Business, Company History and Structure

Visuals shows apprentices that have seen each topic / segmentation

Highlight deficiencies by apprentice per zagaku topic

Slack bot to interact with webserver. -reports -openings - recent topics -zagaku leaderboard

Single button click for Slack invitation / email invitation for solicitation of Zagaku presenter

desktop app for displaying Zagaku's for the week (command bar)

Apprentice voting on topics of interest - initialized through slackbot

Zagaku archive - create new git repo for each zagaku, uploads files, summary, categories. Create from Zagaku webpage, use WYSIWYG react editor, Markdown. Save to git repository, add roll back functionality that calls git reset head REF#

Utilize google OAuth

use input of ISBN for book linking to topics, use to aggregate data on books / topic

ISBN Scanning plus number inside cover for book tracking

Apprentice / Crafter can scan barcode and enter book number to track where books are

iOS / Android through react native

build out service as a react app with backend API (agnostic to web/iOS/Android/OSX)

Last minute cancellation alerts / short time stand by Crafters - crafters can set up a Zagaku for short notice standby. Get alerted within 24 hours of cancellation

Automated reminders to crafters 1 week and 24 hours before Zagaku via Slack

Automated Zagaku scheduling if open slots less than two weeks to one week away, then converts to short time procedure.

Video / Book tracks - Create video and book tracks like timelines that Apprentice / Mentor / Crafter can add. Display each track / series in an index, tracks can be added to Appretice Tracks (like starred list) and items can be checked off as they are completed. Use word count / word complexity to give estimated reading times / watching times. Books might have to be based on length or statistical model.

Apprentice Wiki - question & answer by volunteers. Farm out notifications to apprentice channel, perhaps allow in Slack responses

Code review farming - If someone is seeking a code review, they can link the diff or gist and request. Farm out to slack channel called #PleaseDestroyMyCode or something.

Some sort of github integration?

Apprentice blog aggregation, allowing archiving of an apprentices best blogs.

Cool css animation.

Optional intro css / sound if clicked

Aggregate Slack content from Daily Listen / Daily Read and organize in chronological order

Option on Zagaku creation to flag as BONUS Zagaku, over riding 1 per day limitation

Tech Stack: AWS -> Elixir -> React(Web) -> Native(iOS, MacOS, Android)

Replicate as much content structure into github projects as possible to future proof (if app gains popularity and falls into disuse) no information should be lost if the app is 86ed

Star ratings for content (Podcasts, videos, books)

Categorical segmentation for Podcasts, videos, books

