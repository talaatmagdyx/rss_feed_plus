class DynamicObject
  ## Example usage:
  # data = {
  #   name: "John",
  #   age: 30,
  #   address: {
  #     city: "New York",
  #     state: "NY"
  #   },
  #   hobbies: ["reading", "hiking"]
  # }
  #
  # dynamic_object = DynamicObject.new(data)
  #
  # puts dynamic_object.name   # Output: John
  # puts dynamic_object.age    # Output: 30
  # puts dynamic_object.address.city   # Output: New York
  # puts dynamic_object.address.state  # Output: NY
  # puts dynamic_object.hobbies   # Output: ["reading", "hiking"]

  # A class for initializing objects dynamically based on given data.
  # Initializes a new instance of DynamicInitializer.
  #
  # @param data [Hash] The data used to initialize the object.
  # @return [DynamicInitializer] A new instance of DynamicInitializer.
  def initialize(data)
    data.each do |key, value|
      key = key.to_s
      set_instance_variable(key, value)
      define_singleton_method(key.tr(':', '_')) { instance_variable_get("@#{key.tr(':', '_')}") }
    end
  end

  private

  # Sets an instance variable based on the provided key and value.
  #
  # @param key [String] The key for the instance variable.
  # @param value [Object] The value to be assigned to the instance variable.
  # @return [void]
  def set_instance_variable(key, value)
    if value.is_a?(Hash)
      instance_variable_set("@#{key.tr(':', '_')}", DynamicObject.new(value))
    elsif value.is_a?(Array)
      instance_variable_set("@#{key}", process_array(value))
    else
      instance_variable_set("@#{key}", value)
    end
  end

  # Processes an array, creating DynamicObject instances if elements are hashes.
  #
  # @param array [Array] The array to be processed.
  # @return [Array] The processed array.
  def process_array(array)
    array.map { |v| v.is_a?(Hash) ? DynamicObject.new(v) : v }
  end
end
