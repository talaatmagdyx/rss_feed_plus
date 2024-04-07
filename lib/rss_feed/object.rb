# Monkey-patching the Object class to add convenience methods for checking presence or absence of content.
class Object
  # An object is present if it's not blank.
  #
  # @return [true, false].
  def present?
    !blank?
  end

  # An object is blank if it's false, empty, or a whitespace string.
  # For example, +nil+, '', '   ', [], {}, and +false+ are all blank.
  #
  # This simplifies
  #
  #   !address || address.empty?
  #
  # to
  #
  #   address.blank?
  #
  # @return [true, false]
  def blank?
    # If the object responds to `empty?`, checks if it's empty or equals 'NaN'.
    # Otherwise, checks if the object is nil.
    respond_to?(:empty?) ? (empty? || self == 'NaN') : !self
  end

  # Returns the receiver if it's present otherwise returns +nil+.
  # <tt>object.presence</tt> is equivalent to
  #
  #    object.present? ? object : nil
  #
  # For example, something like
  #
  #   state   = params[:state]   if params[:state].present?
  #   country = params[:country] if params[:country].present?
  #   region  = state || country || 'US'
  #
  # becomes
  #
  #   region = params[:state].presence || params[:country].presence || 'US'
  #
  # @return [Object]
  def presence
    self if present?
  end
end
