# README

## Ruby Version

The Ruby version used is ruby-3.1.

## System Dependencies

The dependencies required and instructions for their installation are found below:

https://guides.rubyonrails.org/development_dependencies_install.html

## Deployment Instructions

After making sure your .ssh/config file is created and upto date, run this command to deploy:

`bundle exec epi_deploy release -d demo`

if you are prompted for a password, you will need to configure your SSH keys. See here for more information:
https://info.shefcompsci.org.uk/faq/deployment/#im-using-macos---how-do-i-deploy

## Database Instructions

We’ve used a postgres database to save user information in this project. To construct and seed the database, run:

`bundle exec rails db:create`

To execute any pending migrations, run:

`bundle exec rails db:migrate`

To reset the database to a clean version from the seed file, run:

`bundle exec rails db:reset`

A full guide to database migrations can be found below.

https://guides.rubyonrails.org/active_record_migrations.html

## Account Details

After following the database instructions,

Two Admin accounts are created with emails:

admin1@planetgo.com
admin2@planetgo.com

Two Reporter accounts are created with emails:

rep1@planetgo.com
rep2@planetgo.com

And two basic user accounts are created with emails:

user1@gmail.com
user2@gmail.com

All passwords are:

SneakyPassword100

## Test Instructions

Tests can be locally run with the command:

`bundle exec rspec`

While in the project root folder, which will generate a coverage report and detail any failures.

## Using Rubocop

To check all Ruby source files in the current directory:

`rubocop`

To automatically fix the problems found in your code run:

`rubocop -A`

For more information visit https://docs.rubocop.org/rubocop/1.45/index.html

## App Features
Coming soon...

## Coding Standards

Insert changes to coding standards here

Ruby: https://github.com/rubocop/rubocop
Rails: https://rails.rubystyle.guide/
Javascript: https://www.w3schools.com/js/js_conventions.asp
