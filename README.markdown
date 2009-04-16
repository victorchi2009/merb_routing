# MerbRouting #

This plugin allows you to use Merb routing in a Ruby on Rails project.

See the [announcement](http://blog.hungrymachine.com/2008/12/29/merb-routing-in-rails/) at [HungryMachine](http://blog.hungrymachine.com/)

## Compatibility ##

Ruby on Rails version 2.3.2 thanks to [Piotr Sarnacki](http://drogomir.com/blog)

Provisional support for rspec-rails thanks to [Bill Burcham](http://blog.thoughtpropulsion.com)

## Integrating with Rspec-Rails ##

Put this in your Spec::Runner.configure block in spec_helper.rb

    config.include ActionController::Routing::Helpers, Merb::Router::UrlHelpers
   
## What Works ##

It looks like routing and URL generation work in running apps and in rspec specs. Both route\_for and params\_from work fine when called from rspec examples.

## What's Still Broken ##

Cucumber stories fail like this:

    When I delete the 3rd frooble             # features/step_definitions/frooble_steps.rb:5
      You have a nil object when you didn't expect it!
      The error occurred while evaluating nil.host_with_port (NoMethodError)
      /Users/Bill/Projects/Rails/merb-routing-test/vendor/plugins/merb_routing/lib/merb-routing/url_helpers.rb:22:in `method_missing'
      ./features/step_definitions/frooble_steps.rb:6:in `/^I delete the (\d+)(?:st|nd|rd|th) frooble$/'
      features/manage_froobles.feature:23:in `When I delete the 3rd frooble'

investigating...
