TokyoPI
=======

What is it?
-----------
An e-mail report generator for [graphite](http://graphite.wikidot.com/). Graphite is a fantastic tool, and makes performance and metric exploration a joy. However, it can be slow to generate large graphs, and has no sense of reporting built in.

TokyoPI is intended to be run as a cron job on a host with access to your graphite instance. It will generate reports based on one or more dashboards and more configuration options than you can shake a stick at.

Why?
---
Because I'm not always going to remember to check my graphite dashboards every day. And you certainly can't expect an entire engineering team to check a dashboard.

In other words, laziness.

Requirements
-----------

+ Ruby 1.9.x. I don't use any servers with 1.8.x anymore, so I have no personal need to support it.
+ A graphite server. I only have a 0.9.9 instance, so that's what I know it works with. It probably supports older versions...
+ A mail server (presently everything uses SMTP via the fantastic [pony](https://github.com/benprew/pony) gem).

Configuration
-------------
By default, configuration is loaded from the `config.yml` file in the directory the script resides.

A sample `config.yml` file is included, with some important values missing.

### Areas to fill in: ###

#### `mail` ####

+ `server`: your smtp mail server
+ `from`: the e-mail address for reports to originate from

#### `reports` ####
This section is the heart of the beast. You can configure an arbitrary number of reports to end up in this hash. The command-line program accepts the name of the report to run, which is the key of the hash entry. If no report is specified, TokyoPI will attempt to run the one named `default`.

#### `email` (optional) ####
If your graphite server is publicly accessible (not recommended) or you only want these emails to work when you have a VPN connection, you can choose `direct_link` as the `image_display_method`. At the moment, the default is `s3`, which dumps the graph images into an s3 bucket.

Additionally, there is a basic architecture for theming, although for now it is only used to dictate the width of the email content box.

#### `s3` (optional) ####
Presently two methods are supported for presenting the graphs in the email client: `s3` and `direct_link`. If you choose `s3`, you'll want to fill in the following items:

+ `bucket`: the name of the s3 bucket
+ `expire_days`: how long the generated links are valid for (days)
+ `access_key`: as provided to you by amazon
+ `secret_access_key`: as provided to you by amazon

#### `graphs` (optional) ####
Here you can configure any additional parameters to be merged in with the graph configuration for your dahsboards. A common use is to override the `width` and `height`, which are stored as URL parameters. Anything that graphite accepts is valid here. Note that you can also have a `graphs` key per-report, which will take priority over any values specified here.

Tests
-----
Unit tests are provided with the goal of increasing coverage over time. At the time of initial commit the coverage is 91%.

All tests can be run without an internet connection, i.e. you don't need an actual graphite or mail server.

I'm still relatively new to unit testing with ruby, so forgive the rspec style.

License
-------
TokyoPI is released under the MIT license: [http://www.opensource.org/licenses/MIT]()

Copyright (c) 2012 Aiden Scandella

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
