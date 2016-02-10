class CB
  __bot           : false
  __activated     : false
  __eventsHandlers: {}

  ###*
  # @param {Number} slot
  # @param {Object} [settings]
  ###
  constructor: (slot = 0, settings) ->
    @__bot = true unless slot is 0
    @__eventsHandlers = {}
    @room_slug = Room.getSlug()
    @slot = slot

    if settings
      @settings = settings
      @__activated = true
    else
      @settings = {}

  ###*
  # Changes the room subject.
  #
  # @param {string} new_subject
  # @see This function is only available to apps, not bots.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.changeRoomSubject.html|cb.changeRoomSubject}
  ###
  changeRoomSubject: (new_subject) ->
    if @__activated and not @__bot
      Room.setSubject(new_subject)

  ###*
  # Requests that all users reload the panel (the HTML info area below the cam). The contents of the panel are controlled by {@link onDrawPanel}.
  #
  # @see This function is only available to apps, not bots.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.drawPanel.html|cb.drawPanel}
  ###
  drawPanel: ->
    if @__activated and not @__bot
      Room.drawPanel()

  ###*
  # Hides the cam feed from viewers and shows them a custom message. You can optionally pass in an array of usernames of whom you’d like to be able to view the cam.
  #
  # @param {string} message
  # @param {Array} allowed_users
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_start: (message, allowed_users) -> Room.setCam(running: true, message: message, users: allowed_users)

  ###*
  # Stops the camera from being hidden from viewers, returning the broadcaster to public broadcasting.
  #
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_stop: -> Room.setCam(running: false)

  ###*
  # Add an array of usernames to allow viewing of the cam while it is hidden to others. You can use this before, during, or after you start/stop limiting the cam.
  #
  # @param {Array} allowed_users
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_addUsers: (allowed_users) -> Room.setCam(addUsers: allowed_users)

  ###*
  # Remove an array of usernames to no longer be able to view the cam.
  #
  # @param {Array} removed_users
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_removeUsers: (removed_users) -> Room.setCam(removeUsers: removed_users)

  ###*
  # Remove all viewers from being able to view the cam.
  #
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_removeAllUsers: -> Room.setCam(users: [])

  ###*
  # Check if a particular username is in the list of those allowed to view the cam.
  #
  # @param {string} user
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_userHasAccess: (user) -> user in Room.getCam().users

  ###*
  # Get an array of the usernames that are allowed to view the cam.
  #
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_allUsersWithAccess: -> Room.getCam().users

  ###*
  # Check if the cam is viewable by those not in the allowed list.
  #
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
  ###
  limitCam_isRunning: -> Room.getCam().running

  ###*
  # Adds a debug message to the chat. These log messages are broadcast to the chat room, but you must enable debug mode to see them.
  # To enable or disable debug mode, type /debug into chat.
  #
  # @param {string} message
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.log.html|cb.log}
  ###
  log: (message) ->
    if @__activated
      Room.log(message)

  ###*
  # Return data needed to display the info panel for a user.
  # The return value is a key-value set with a template key. Depending on the template chosen, additional keys should be passed in.
  # For more information, see {@link https://chaturbate.com/apps/docs/api/cb.onDrawPanel.html#available-templates|Available Templates}.
  #
  # @param {Function} func
  # @see This function is only available to apps, not bots.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onDrawPanel.html|cb.onDrawPanel}
  ###
  onDrawPanel: (func) ->
    if not @__bot and func instanceof Function
      @__eventsHandlers.drawPanel = func

  ###*
  # Receive a notification when a registered member enters the room.
  #
  # @param {Function} func - The func argument should be a function that receives 1 argument itself, user.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onEnter.html|cb.onEnter}
  ###
  onEnter: (func) ->
    if func instanceof Function
      @__eventsHandlers.enter = func

  ###*
  # Receive a notification when a registered member leaves the room.
  #
  # @param {Function} func - The func argument should be a function that receives 1 argument itself, user.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onLeave.html|cb.onLeave}
  ###
  onLeave: (func) ->
    if func instanceof Function
      @__eventsHandlers.leave = func

  ###*
  # Receive a notification when a message is sent.
  #
  # Your app can manipulate the message.
  # You must return the original message object.
  #
  # @param {Function} func - The func argument should be a function that receives 1 argument itself, message.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onMessage.html|cb.onMessage}
  ###
  onMessage: (func) ->
    if func instanceof Function
      @__eventsHandlers.message = func

  ###*
  # Receive a notification when a tip is sent.
  #
  # @param {Function} func - The func argument should be a function that receives 1 argument itself, tip.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onTip.html|cb.onTip}
  ###
  onTip: (func) ->
    if func instanceof Function
      @__eventsHandlers.tip = func

  ###*
  # A variable that contains the name of the current room.
  #
  # @type {string}
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.room_slug.html|cb.room_slug}
  #
  # @example
  # // This can be used to determine if a message is being sent by the broadcaster.
  # if (msg['user'] == cb.room_slug) { cb.chatNotice("Message sent by broadcaster") }
  ###
  room_slug: ''

  ###*
  # A variable that contains the slot which the app is running.
  #
  # @type {Number}
  ###
  slot: 0

  ###*
  # Send a message to the room.
  #
  # You can use a \n inside the message to send a multi-line notice.
  # You may use :emoticons in the notice.
  #
  # @param {string} message
  # @param {string} [to_user]
  # @param {string} [background] - Only HTML color codes (such as #FF0000)
  # @param {string} [foreground] - Only HTML color codes (such as #FF0000)
  # @param {"normal"|"bold"|"bolder"} [weight]
  # @param {"red"|"green"|"darkblue"|"lightpurple"|"darkpurple"|"lightblue"} [to_group]
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.sendNotice.html|cb.sendNotice}
  ###
  sendNotice: (message, to_user, background, foreground, weight, to_group) ->
    if @__activated
      Room.notice(message, to_user, background, foreground, weight, to_group)

  ###*
  # Alias to sendNotice
  #
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.chatNotice.html|cb.chatNotice}
  # @deprecated
  ###
  chatNotice: @:: sendNotice

  ###
  # Calls a function or executes a code snippet after a specified number of milliseconds.
  #
  # @param {Function} func
  # @param {Number} msecs
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.setTimeout.html|cb.setTimeout}
  ###
  setTimeout: (func, msecs) ->
    if @__activated
      window.setTimeout(func, msecs)

  ###*
  # Set this variable in order to have a form filled out by the broadcaster before the app is launched.
  #
  # For each name in cb.settings_choices, there will be a value loaded in cb.settings.
  #
  # @type {Array}
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.settings_choices.html|cb.settings_choices}
  ###
  settings_choices: []

  ###*
  # For each name in cb.settings_choices, there will be a value loaded in cb.settings.
  #
  # @type {Object}
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.settings_choices.html|cb.settings_choices}
  ###
  settings: {}

  ###*
  # When users send a tip, present them with a list of messages to send with their tip.
  # These messages can be received and processed later by {@link onTip}.
  #
  # @param {Function} func
  # @see This function is only available to apps, not bots.
  # @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.tipOptions.html|cb.tipOptions}
  ###
  tipOptions: (func) ->
    if not @__bot and func instanceof Function
      @__eventsHandlers.tipOptions = func
