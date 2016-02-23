class CBJS
  ###*
  # Returns true if array contains at least once instance of object.
  #
  # @param {Array} array
  # @param {Object} object
  ###
  @arrayContains: (array, object) -> object in array

  ###*
  # Removes all instances of object from array and returns the new array.
  #
  # @param {Array} array
  # @param {Object} object
  ###
  @arrayRemove: (array, object) -> array.filter (obj) -> obj isnt object

  ###*
  # Joins all elements of an array into a string.
  #
  # @param {Array} array
  # @param {string} separator
  ###
  @arrayJoin: (array, separator) -> array.join(separator)
