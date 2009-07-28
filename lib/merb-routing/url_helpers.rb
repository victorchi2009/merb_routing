# this translates url_for, polymorphic_path, and rails named routes into merb routes
module Merb::Router::UrlHelpers
  def url(name, *args)
    args << params
    name = request.route if name == :this
    Merb::Router.url(name, *args)
  end

  def method_missing_with_merb_routing(method_id, *args, &block)
    if /^(formatted_)?(.*)(_url|_path)$/.match(method_id.to_s)
      route_name = $2.to_sym
      options, args = args.last.is_a?(Hash) ? [args.pop, args] : [{}, args]
      
      if $1 == 'formatted_'
        options[:format] = args.pop
      end
      
      host_prefix = ""
      if $3 == '_url' || options.delete(:only_path) == false
        route = Merb::Router.named_routes[route_name]
        host_prefix << (options.delete(:protocol) || (route && route.conditions[:protocol]) || "http://")
        host_prefix << "#{CGI.escape(options.delete(:user))}:#{CGI.escape(options.delete(:password))}@" if options[:user] && options[:password]
        host_prefix << (options.delete(:host) || (route && route.conditions[:host]) || (request ? request.host_with_port : host))
        host_prefix << ":#{options.delete(:port)}" if options.key?(:port)
      end
      
      return host_prefix + Merb::Router.url(route_name, *(args << options << {}))
    else
      method_missing_without_merb_routing(method_id, *args, &block)
    end
  end
end

__END__

# Put this in your spec_helper.rb to help Merb Routing and RSpec play nice together.

module MerbRoutingRspecHoneymoon
  include ActionController::Routing::Helpers
  include Merb::Router::UrlHelpers

  def method_missing(sym, *args, &block)     
    return method_missing_with_merb_routing(sym, *args) if /^(formatted_)?(.*)(_url|_path)$/.match(sym.to_s)
    return Spec::Matchers::Be.new(sym, *args) if sym.to_s =~ /^be_/
    return Spec::Matchers::Has.new(sym, *args) if sym.to_s =~ /^have_/
    super
  end
end

ActiveSupport::TestCase.send(:include, MerbRoutingRspecHoneymoon)
