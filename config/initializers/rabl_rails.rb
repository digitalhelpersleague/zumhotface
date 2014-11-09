RablRails.configure do |config|
  config.cache_templates = false
  config.include_json_root = false
  # config.json_engine = ::Oj
  # config.xml_options = { :dasherize => true, :skip_types => false }
  # config.use_custom_responder = false
  # config.default_responder_template = 'show'
  # config.enable_jsonp_callbacks = false
  # config.replace_nil_values_with_empty_strings = false
  # config.replace_empty_string_values_with_nil = false
  config.exclude_nil_values = true
end
