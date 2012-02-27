module MagicRouting
  def options_as_params_with_magic_routing(options)
    options_as_params = options_as_params_without_magic_routing(options)

    # if the provided option is an ActiveRecord::Base object (proxied here by respond_to?(:columns))  
    # and it has a column corresponding to the option key, and the key is not :id (which is  
    # handled by to_param), use that value instead of the object's to_param. E.g., 
    # 
    #   :username => Account.find(:first) ==> '.../bob', instead of '.../1' 

    options_as_params.each do |key, value|
      if key != :id && value.respond_to?(:attributes) && value.attributes.is_a?(Hash) && value.attributes.has_key?(key.to_s)
        options_as_params[key] = value.send(key) if value.respond_to?(key)
      end
    end

    options_as_params
  end
end