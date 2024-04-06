class DynamicObject
  def initialize(data)
    data.each do |key, value|
      key = key.to_s
      if value.is_a?(Hash)
        instance_variable_set("@#{key.gsub(':', '_')}", DynamicObject.new(value))
      elsif value.is_a?(Array)
        instance_variable_set("@#{key}", value.map { |v| v.is_a?(Hash) ? DynamicObject.new(v) : v })
      else
        instance_variable_set("@#{key}", value)
      end
      define_singleton_method(key.gsub(':', '_')) { instance_variable_get("@#{key.gsub(':', '_')}") }
    end
  end
end
