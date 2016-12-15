# Whiteboard

## Overview

Whiteboard is an app which aims to increase the effectiveness of office-wide standups, and increase communication with the technical community by sharing what we learn with the outside world.  It does this by making two things easy - emailing a summary of the standup to everyone in the company and by creating a blog post of the items which are deemed of public interest.

## Background

At Pivotal Labs we have an office-wide standup every morning at 9:06 (right after breakfast). The current format is new faces (who's new in the office), helps (things people are stuck on) and interestings (things that might be of interest to the office).

Before Whiteboard, one person madly scribbled notes, and one person ran standup using a physical whiteboard as a guide to things people wanted to remember to talk about.  Whiteboard provides an easy interface for people to add items they want to talk about, and then a way to take those items and assemble them into a blog post and an email with as little effort as possible.  The idea is to shift the writing to the person who knows about the item, and reduce the role of the person running standup to an editor.

## Features

- Add New Faces, Helps and Interesting
- Summarize into posts
- Two click email sending (the second click is for safety)
- Two click Posts to Wordpress (untransformed markdown at the moment)
- Allow authorized IP addresses to access boards without restriction
- Allows users to sign in using Okta if their IP is not Whitelisted

## Usage

- Deploy to Cloud Foundry.
- Tell people in the office to use it. 
- At standup, go over the board, then add a title and click 'create post'.
- The board is then cleared for the next day, and you can edit the post at your leisure and deliver it when ready.

## Development

Whiteboard is a Rails 4 app. It uses rspec with capybara for request specs.  Please add tests if you are adding code.

Whiteboard feature tests are incompatible with Qt 5.5, ensure you have a lower version installed before running `bundle`

Whiteboard [is on Pivotal Tracker](https://www.pivotaltracker.com/projects/560741).

A string including all the IPs used by your office is required as an environment variable in order for IP fencing to work.

The format should be a single string of IPs, e.g. `192.168.0.1` or IP ranges in slash notation, e.g. `64.168.236.220/24` separated by a single comma like so: 

```
192.168.1.1,127.0.0.1,10.10.10.10,33.33.33.33/24
```

Export this string:
```
export IP_WHITELIST=<ip_string>
```

Whiteboard is setup by default to whitelist 127.0.0.1 (localhost) by default to allow the tests to pass. This is located in the .env.test file.

## Testing

Before running tests, make sure to add your local IP to the IP_WHITELIST environment variable string. Then run

```
bundle exec rspec
```

## How to Deploy to Cloud Foundry

* Edit the [Production manifest](./config/cf-production.yml) if needed before pushing out to PCF

```
cf login -a https://api.run.pivotal.io -o corelogic-org -s production
rake production deploy
```

## Author

Whiteboard was written by [Matthew Kocher](https://github.com/mkocher).

## License

Whiteboard is MIT Licensed. See MIT-LICENSE for details.
