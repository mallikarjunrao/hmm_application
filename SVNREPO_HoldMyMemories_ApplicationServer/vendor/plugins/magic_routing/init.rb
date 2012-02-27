require 'magic_routing'

ActionController::Routing::RouteSet.send(:include, MagicRouting)
ActionController::Routing::RouteSet.send(:alias_method_chain, :options_as_params, :magic_routing)
