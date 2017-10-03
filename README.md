# Whiteboard

At CoreLogic Labs, we have an office-wide standup every morning at 9:06am (right after breakfast)

The current format is:

- *New faces*: who's new in the office
- *Helps*: things people are stuck on
- *Interestings*: things that might be of interest to the office
- *Events*: things going on that day, both in the office and in the local community

It is deployed at [http://corelogic-whiteboard.cfapps.io](http://corelogic-whiteboard.cfapps.io)

## Usage

- Go to [the office standups homepage](http://corelogic-whiteboard.cfapps.io/standups) to see a list of office standups

   - If your office is missing, you will need to add it by clicking on the "New Standup" button and configure it similar to the other office standups
    
       > **Note:** You can see what a configuration looks like by clicking the "Preferences" link in their office standup, similar to [this configuration for the Rancho Cordova office](http://corelogic-whiteboard.cfapps.io/standups/2/edit))

- Before the daily standup, go to the board and add an entry in either the "New Faces", "Helps", "Interestings", or "Events" section
   
- At standup, go over the board and click the "Presentation" button
   
   - You can use the right/left arrow keys to navigate through the presentation

- After standup, the host(s) for the day should enter their name(s) and a brief subject in the "Send Standup Email" section and click the "Send Email" button in order to publish that day's standup email to their office distribution list

## Development

For CoreLogic's use, we aren't actively developing the Whiteboard application, we just use it.

Feel free to check out the original repository for Pivotal's latest changes [here](https://github.com/pivotal/whiteboard)

## The IP Address Whitelist

Since this application was built for Pivotal's internal use, they have it configured to communicate with Okta to login to the application.

None of the CoreLogic employees have access to this, so our workaround is to allow **unauthenticated** access from the *outbound* IP addresses of each of the CoreLogic Labs offices.

The below list is the latest configuration:

| Office             | IP Address                                |
| ---                | ---                                       |
| Oxford, MS         | 198.178.56.26, 198.178.56.27, 69.87.112.1 | 
| Rancho Cordova, CA | 69.87.100.1                               |
| Santa Monica, CA   | 204.93.49.98                              |

These values should match what is in the [Production manifest](./config/cf-production.yml).


### Updating the IP Address Whitelist

If a new IP address needs to be added, you can update the application by going through the below steps:

* Update this README with that office's name and IP address in the list above
* Update the [Production manifest](./config/cf-production.yml) with a comma delimited entry of the new IP address
* Execute the below commands to update the application in PCF:

   ```
   cf login -a https://api.run.pivotal.io -o corelogic-org -s production
   cf set-env corelogic-whiteboard IP_WHITELIST <addresses-from-manifest>
   cf restage corelogic-whiteboard
   ```
   
## Deploying to Cloud Foundry

> **IMPORTANT**
> 
> This application is currently deployed to Production, and is quite difficult to build/deploy, so this section is mostly here as a historical reference.

In order to deploy this, you will need to have installed quite a few things

* Go through the [Pivotal developer workstation setup](https://github.com/pivotal/workstation-setup)
* Install XCode (through the App Store)
* Run the below commands:

   ```
	brew install mysql
	
	brew install qt@5.5
	brew link --force qt55
	
	ln -s /usr/local/opt/readline/lib/libreadline.dylib /usr/local/opt/readline/lib/libreadline.6.dylib
	
	bundle install	
   ```
* Run the below commands to push the application out:

   ```
   cf login -a https://api.run.pivotal.io -o corelogic-org -s production
   rake production deploy
   ```
