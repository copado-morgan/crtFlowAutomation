# crtFlowAutomation

Description:
Unless you have test coverage for your salesforce flows, they deploy inactive to production. While the preferred scenario would be to have test coverage for flows, most organizations aren't at that point yet. This project is a collection of 2 Copado Robotic Testing scripts that will activate flows for you after deployment. One relies on a list of flow names in an xlsx file. The other script scrapes the list of flows modified today and clicks activate for each one.

Setup directions:

In your salesforce org:
Navigate to setup -> Flows
Clone your all stories list view
Name this view flowsModifiedToday for both the label and the api name.
There needs to be 10 fields in this list view. That's just the way I built it, contribute a fix if you don't like it. Flow Label is a required field, the rest are up to you.

In your copado robotic testing org:
Create a new project (or just dump these tests in an existing one, idc)
I built these in two separate suites. It's just easier to trigger them that way, but there's no reason you can't put them in one and trigger them using a tag or exact test name.
On your test suite(s), create the variables login_url, password, and username. Populate these with your production values.
You need a resources and tests folder
you need a common.robot in the resources folder. If you don't have one, copy mine. At a minimum, you need the "setup" and "Activate Flow" keywords and the included variables and libraries.
Create the two robot files, copy and paste my code into the files.
