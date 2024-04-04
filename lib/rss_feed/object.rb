# Monkey-patching the Object class to add convenience methods for checking presence or absence of content.
class Object
  # Checks if the object is not blank.
  #
  # @return [Boolean] true if the object is not blank, false otherwise.
  def present?
    !blank?
  end

  # Checks if the object is blank.
  #
  # @return [Boolean] true if the object is blank, false otherwise.
  def blank?
    # If the object responds to `empty?`, checks if it's empty or equals 'NaN'.
    # Otherwise, checks if the object is nil.
    respond_to?(:empty?) ? (empty? || self == 'NaN') : !self
  end
end
