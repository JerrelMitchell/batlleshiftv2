
# Battleshift

## Stephen & Jerrel

[![Waffle.io - Columns and their card count](https://badge.waffle.io/JerrelMitchell/batlleshiftv2.svg?columns=all)](https://waffle.io/JerrelMitchell/batlleshiftv2)

We built on top of a pre-existing API implementation of the game Battleship. For this project we added multiplayer functionality and basic levels of security.

## Learning Goals
Lock down an API using unique keys
Build on top of brownfield code
Empathy for developers facing deadlines
Empathy for teammates that might work with your code in the future (or future you!)
Prioritize what code is relevant to your immediate task (and ignore the rest)
Send email from a Rails application


## User Stories
As a guest user
When I visit "/"
And I click "Register"
Then I should be on "/register"
And when I fill in an email address (required)
And I fill in name (required)
And I fill in password and password confirmation (required)
And I click submit
Then I should be redirected to "/dashboard"
And I should see a message that says "Logged in as <SOME_NAME>"
And I should see "This account has not yet been activated. Please check your email."

Background: The registration process will trigger this story
As a non-activated user
When I check my email for the registration email
I should see a message that says "Visit here to activate your account."
And when I click on that link
Then I should be taken to a page that says "Thank you! Your account is now activated."
And when I visit "/dashboard"
Then I should see "Status: Active"

Background: The registration process will trigger this story
As a non-activated user
When I check my email for the registration email
Then I should see a unique API key to use for making API calls
