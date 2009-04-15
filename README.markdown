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

It looks like routing and URL generation work in running apps. There are some problems however, with specs...

## What is Broken ##

Routing specs call route\_for and params\_from which in turn call methods in the guts of Rails routing. Until those guts are faked out you'll see errors like this in your routing spec output:

    NoMethodError in 'FrooblesController route recognition generates params for #show'
    undefined method `recognize_path' for #<ActionController::Routing::MerbRoutingWrapper:0x26163d4>
    ./spec/routing/froobles_routing_spec.rb:48:
 
and

    Test::Unit::AssertionFailedError in 'FrooblesController route generation maps #index'
    The recognized options <{"format"=>nil, "action"=>"index", "controller"=>"froobles"}> did not match <{"action"=>"index",
    "controller"=>"froobles"}>, difference: <{"format"=>nil}>
    ./spec/routing/froobles_routing_spec.rb:6:
 
We're getting close.

## Something Cool to Try ##

