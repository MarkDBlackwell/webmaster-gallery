# webmaster-gallery

Picture gallery for webmasters (an application written in Rails 3).

## Description

This app is for individual webmasters who use a web-hosting service (in particular, users of cPanel virtual hosts).

The webmaster uploads pictures, thumbnails and CSS to a directory, then runs the app to update the picture descriptions.

It has been successfully installed (and run, on cPanel).

An art gallery (of the app's first client) is [visible](http://www.meganamoss.com/webmas-gallery/) (actually the static pages generated).

## Usage

Unzip the downloaded app (use the ZIP GitHub button), upload it to your cPanel host in a folder of your choosing and uncompress.

On the cPanel page, 'Manage Ruby on Rails Applications', create a Rails application.

Follow this blog [post](http://markdblackwell.blogspot.com/2011/03/install-rails-3-application-to-cpanel_23.html). Some of the 
steps are already done in the app.

## Testing

[User stories](webmaster-gallery/blob/master/test/stories.txt) for webmasters and their users (gallery viewers) are up-to-date and accurate.

See a [quick start](webmaster-gallery/blob/master/test/quick-start.txt) to developer testing of the app (using Test/Unit).

All the app's tests passed, as of Rails version 3.0.3 (using ruby 1.8.7, along with rake 0.8.7).

## References

[Install Rails 3 application to cPanel in sub-URI, howto](http://markdblackwell.blogspot.com/2011/03/install-rails-3-application-to-cpanel_23.html)

Copyright (c) 2011 Mark D. Blackwell. See [MIT-LICENSE](webmaster-gallery/blob/master/MIT-LICENSE) for details.
