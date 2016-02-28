class Room
  broadcaster = 'broadcaster'
  defaultSubject = broadcaster.charAt(0).toUpperCase() + broadcaster.slice(1) + "'s room"
  subject = defaultSubject
  debug = false
  apps = [ {}, {}, {}, {} ]

  cam =
    running: false
    message: ''
    users  : []

  icons =
    m: {src: 'cb/images/ico-male-blue.gif', alt: 'Male Icon'}
    f: {src: 'cb/images/ico-female-blue.gif', alt: 'Female Icon'}
    c: {src: 'cb/images/ico-couple-blue.gif', alt: 'Couples Icon'}
    s: {src: 'cb/images/ico-shemale-blue.gif', alt: 'Transsexual Icon'}

  Message = ({c, m, f}) ->
    c: c or '#494949' # message color
    m: m or '' # the message text
    f: f or 'default' # message font

  User = ({user, in_fanclub, has_tokens, is_mod, tipped_recently, tipped_alot_recently, tipped_tons_recently, gender}) ->
    user                : user or '' # username of the user
    in_fanclub          : in_fanclub or false # is the user in the broadcasters fan club
    has_tokens          : has_tokens or false # does the user have at least 1 token
    is_mod              : is_mod or false # is the user a moderator
    tipped_recently     : tipped_recently or false # is the user a "dark blue"
    tipped_alot_recently: tipped_alot_recently or false # is the user a "purple"
    tipped_tons_recently: tipped_tons_recently or false # is the user a "dark purple"
    gender              : gender or '' # "m" (male), "f" (female), "s" (trans), or "c" (couple)

  Tip = ({amount, message, to_user, from_user, from_user_in_fanclub, from_user_has_tokens, from_user_is_mod, from_user_tipped_recently, from_user_tipped_alot_recently, from_user_tipped_tons_recently, from_user_gender}) ->
    amount                        : amount or 0 # amount of tip
    message                       : message or '' # message in tip
    to_user                       : to_user or '' # user who received tip
    from_user                     : from_user or '' # user who sent tip
    from_user_in_fanclub          : from_user_in_fanclub or false # is the user in the broadcasters fan club
    from_user_has_tokens          : from_user_has_tokens or false # does the user have at least 1 token
    from_user_is_mod              : from_user_is_mod or false # is the user a moderator
    from_user_tipped_recently     : from_user_tipped_recently or false # is the user a "dark blue"?
    from_user_tipped_alot_recently: from_user_tipped_alot_recently or false # is the user a "purple"?
    from_user_tipped_tons_recently: from_user_tipped_tons_recently or false # is the user a "dark purple"?
    from_user_gender              : from_user_gender or '' # "m" (male), "f" (female), "s" (trans), or "c" (couple)

  currentUser = broadcaster
  users = [
    User(user: broadcaster, has_tokens: true, gender: 'm')
    User(user: 'grey', has_tokens: false, gender: 'm')
    User(user: 'hasTokens', has_tokens: true, gender: 'm')
    User(user: 'fan', in_fanclub: true, has_tokens: true, gender: 'm')
    User(user: 'mod', is_mod: true, has_tokens: true, gender: 'm')
    User(user: 'tippedRecently', tipped_recently: true, has_tokens: true, gender: 'm')
    User(user: 'tippedAlotRecently', tipped_alot_recently: true, has_tokens: true, gender: 'm')
    User(user: 'tippedTonsRecently', tipped_tons_recently: true, has_tokens: true, gender: 'm')
  ]

  getSettings = (settings_choices, slot, callback) ->
    app = apps[slot]

    buildSettingLine = (setting, value = setting.defaultValue or setting.default) ->
      $line = $('<tr><th><label></label></th><td colspan="2"></td></tr>')

      $line.find('th').addClass('requiredfield') if setting.required isnt false
      $line.find('label').attr('for', 'id_' + setting.name).text(setting.label + (if setting.type isnt 'choice' then ':' else ''))

      switch setting.type
        when 'int'
          $input = $('<input type="number">').attr(
            id  : 'id_' + setting.name
            name: setting.name
            min : setting.minValue if setting.minValue isnt undefined
            max : setting.maxValue if setting.maxValue isnt undefined
          )
          $input.val(value)
          $line.find('td').append($input)
        when 'str'
          $input = $('<input type="text">').attr(
            id       : 'id_' + setting.name
            name     : setting.name
            minLength: setting.minLength if setting.minLength isnt undefined
            maxLength: setting.maxLength if setting.maxLength isnt undefined
          )
          $input.val(value)
          $line.find('td').append($input)
        when 'choice'
          $select = $('<select>').attr(
            id  : 'id_' + setting.name
            name: setting.name
          )

          while choice = setting['choice' + (++i or i = 1)]
            $select.append($('<option>').val(choice).text(choice).attr({selected: 'selected' if choice is value}))

          $line.find('td').append($select)

      $line

    if settings_choices and settings_choices instanceof Array and settings_choices.length > 0
      appOptions = open('', 'cb-testbed-app' + slot, 'width=768,height=576,location=0,menubar=0,status=0,toolbar=0', true)

      if appOptions
        if appOptions.location.host is ''
          appOptions.history.pushState('', '', window.location.origin + '/options?slot=' + slot);
          appOptions.document.write('<html><head><title>' + app.name + ' Options</title><link rel="stylesheet" href="cb/css/settings.css" type="text/css"></head><body><form id="app_start_form"><table><tbody></tbody></table><input type="submit"></form></body></html>')

          $(appOptions.document.body).find('input[type=submit]').val('Start ' + (if slot is 0 then 'App' else 'Bot'))
          $(appOptions.document.body).find('tbody').append(buildSettingLine(setting, app.settings[setting.name])) for setting in settings_choices
          $(appOptions.document.body).find('form').on 'submit', ->
            app.settings = $(this).serializeArray().reduce(((settings, setting) -> settings[setting.name] = setting.value; settings), {})
            callback $.extend({}, app.settings)
            appOptions.close()

            return false

        appOptions.focus()
      else
        alert('Allow pop-ups from this page to view the options.')
    else
      callback {}

  appendToChatList = ($node) ->
    $chatList = $('#defchat').find('div.section > div.chat-holder > div > div.chat-list').append($node)

    if $chatList.children().length > 200
      $chatList.find('> div.text:first-child').remove()

    $node

  triggerHandler = (type, obj) ->
    for app in apps.slice().reverse()
      if app.cb instanceof CB and app.cb.__activated and handler = app.cb.__eventsHandlers[type]
        try
          result = handler(obj)
          obj = result if result and (type != 'message' or (result instanceof Object and result.m isnt undefined))
        catch e
          Room.error(e.message, 'An error occurred: ')
          Room.deactivateApp(app.cb.slot)

    return obj

  getEmoticons = (message) ->
    message.replace(/(^|\s):([A-Za-z0-9_]+)/g, '$1<img src="cb/emoticons/$2.jpg" title=":$2" onerror="$(this).replaceWith(\':$2\')">')

  getUserTypeClass = (user) ->
    switch
      when user.user is broadcaster then 'hostmessagelabel'
      when user.is_mod then 'moderatormessagelabel'
      when user.in_fanclub then 'fanclubmessagelabel'
      when user.tipped_tons_recently then 'tippedtonsrecentlymessagelabel'
      when user.tipped_alot_recently then 'tippedalotrecentlymessagelabel'
      when user.tipped_recently then 'tippedrecentlymessagelabel'
      when user.has_tokens then 'hastokensmessagelabel'
      else
        ''

  buildPanel = (panelOptions) ->
    $table = $('<table class="goal_display_table panel"><tbody>')
    $row1 = $('<tr class="dark_blue">')
    $row2 = $('<tr class="dark_light_blue">')
    $row3 = $('<tr class="dark_blue">')
    $table.find('tbody').append($row1, $row2, $row3)

    switch panelOptions.template
      when '3_rows_of_labels'
        $table.removeClass('panel')

        $row1.append $('<th>').append $('<div class="counter_label_green">').append panelOptions.row1_label
        $row1.append $('<td class="data">').append panelOptions.row1_value

        $row2.append $('<th>').append $('<div class="counter_label">').append panelOptions.row2_label
        $row2.append $('<td class="data">').append panelOptions.row2_value

        $row3.append $('<th>').append $('<div class="counter_label">').append panelOptions.row3_label
        $row3.append $('<td class="data">').append panelOptions.row3_value
      when '3_rows_11_21_31'
        $table.addClass('table_3_rows_11_21_31')

        $row1.append $('<td class="data center">').append $('<strong>').append panelOptions.row1_value

        $row2.append $('<td class="data center">').append panelOptions.row2_value

        $row3.append $('<td class="data center">').append panelOptions.row3_value
      when '3_rows_12_21_31'
        $row1.append $('<th>').append $('<div class="counter_label">').append panelOptions.row1_label
        $row1.append $('<td class="data">').append panelOptions.row1_value

        $row2.append $('<td colspan="2" class="data center">').append panelOptions.row2_value

        $row3.append $('<td colspan="2" class="data center">').append panelOptions.row3_value
      when '3_rows_12_22_31'
        $row1.append $('<th>').append $('<div class="counter_label">').append panelOptions.row1_label
        $row1.append $('<td class="data">').append panelOptions.row1_value

        $row2.append $('<th>').append $('<div class="counter_label">').append panelOptions.row2_label
        $row2.append $('<td class="data">').append panelOptions.row2_value

        $row3.append $('<td colspan="2" class="data center">').append panelOptions.row3_value
      else
        return 'App Error: Template "' + panelOptions.template + '" is missing.'

    return $table

  updateUserList = ->
    $__users = $('#__users').text('')
    for _user in Room.getUsers()
      $('body').append $_temp = $('<div class="chat-list"><span class="' + getUserTypeClass(Room.getUser(_user)) + '">').hide()
      color = $_temp.find('span').css('color')
      $_temp.remove()

      $__users.append $('<option>').text(_user).css({color: color})
    $__users.val(currentUser).css({color: $__users.find(":selected").css('color')})

    $('.chat-box .buttons span.usercount').text(Room.getUsers().length)

  loadScript = ({script, slot, name, defaultSettings}, deactivateCallback) ->
    if script
      Room.deactivateApp(slot)

      app = apps[slot] = {}
      app.name = name or if slot is 0 then 'CBApp' else 'CBBot #' + slot
      app.script = script
      app.settings = defaultSettings or {}
      app.deactivateCallback = deactivateCallback

    Room.updateUI()

  @activateApp: (slot) ->
    @deactivateApp(slot)
    app = apps[slot]

    runScript = (cb = new CB(slot)) ->
      mask = {}
      for p in Object.keys(@) then mask[p] = undefined
      mask['cb'] = cb
      mask['cbjs'] = CBJS

      try
        (->
          `with (this) {
            eval(app.script)
          }`
          return
        ).call mask
      catch e
        if cb.__activated
          Room.error('App Error: ' + e.message)
          Room.deactivateApp(cb.slot)

      return cb

    getSettings runScript().settings_choices, slot, (settings) ->
      runScript(app.cb = new CB(slot, settings)).sendNotice(app.name + ' app has started.')

      Room.updateUI()

    return false

  @deactivateApp: (slot) ->
    app = apps[slot]

    if app and app.cb instanceof CB
      app.cb = app.cb.__activated = null
      app.deactivateCallback(app) if app.deactivateCallback instanceof Function

    @updateUI()

    return false

  @loadApp: (path, slot, defaultSettings) ->
    $.ajax(
      url     : path,
      dataType: 'text',
      success : (script) -> loadScript({script, slot, defaultSettings}, (app) -> Room.loadApp(path, slot, app.settings))
    )

    return

  @loadAppFromCB: (name, slot) ->
    $.ajax(
      url     : 'https://cors-anywhere.herokuapp.com/https://chaturbate.com/apps/sourcecode/' + name + '/?slot=' + slot,
      dataType: 'text',
      success : (data) ->
        $appPage = $(data.replace(/src="[^"]*"/g, ''))

        script = $appPage.find('textarea.form_sourcecode').text()
        name = $appPage.find('div#app_title').text().trim()

        loadScript({script, slot, name})
      error   : (jqXHR, textStatus, errorThrown) ->
        console.error(jqXHR, textStatus, errorThrown)
        alert('Failed to load the App "' + name + '".\nError: ' + errorThrown)
    )

    return

  @loadAppFromFile: (slot) ->
    $("#app_js_file").off('change').on('change', (e) ->
      file = e.target.files[0]

      if file
        fileReader = new FileReader
        fileReader.addEventListener 'load', (e) ->
          script = e.target.result
          loadScript({script, slot}) if script
        fileReader.readAsText(file)

        $(this).replaceWith($('<input id="app_js_file" type="file" accept="application/javascript"/>').hide())
    ).trigger('click')

    return

  @message: (message) ->
    if message is '/debug'
      $debug = appendToChatList($('<div class="text"><p>'))
      $debug.find('p').text('Debug mode ' + if not debug then 'enabled. Type /debug again to disable.' else 'disabled.')
      debug = not debug

    else if match = message.match(/^\/tip(?:\s(?:([0-9]+)(?:\s(.*))?)?)?$/)
      if currentUser isnt broadcaster
        amount = match[1]
        message = match[2]

        $tip_popup = $('.tip_shell div.overlay_popup.tip_popup')
        $tip_amount = $tip_popup.find('#id_tip_amount')
        $tip_msg_input = $tip_popup.find('#id_tip_msg_input')

        $tip_amount.val(amount) if amount = parseInt(amount)
        $tip_msg_input.val(message) if message

        $tip_popup.show()
        $tip_amount.select()

    else if message
      $message = appendToChatList($('<div class="text"><p><span class="username messagelabel">'))

      message = $.extend {}, @getCurrentUser(), Message(m: message)
      message = triggerHandler 'message', message

      $message.css({color: message.c, fontFamily: message.f if message.f isnt 'default'})
      $message.find('span.username').attr('data-nick', message.user).text(message.user + ':').addClass getUserTypeClass(message)
      $message.find('p').append(getEmoticons(message.m))
      $message.find('p').append($('<span class="__debug">').css({color: '#CCC'}).text(' [hidden]')) if message['X-Spam']

    return

  @tip: (amount, message) ->
    user = @getCurrentUser()

    tip = Tip(
      amount                        : parseInt(amount),
      message                       : message,
      to_user                       : broadcaster,
      from_user                     : user.user,
      from_user_in_fanclub          : user.in_fanclub,
      from_user_has_tokens          : user.has_tokens,
      from_user_is_mod              : user.is_mod,
      from_user_tipped_recently     : user.tipped_recently,
      from_user_tipped_alot_recently: user.tipped_alot_recently,
      from_user_tipped_tons_recently: user.tipped_tons_recently,
      from_user_gender              : user.gender
    )

    $tip = appendToChatList($('<div class="text"><p><span class="tipalert"><span class="username othermessagelabel">'))

    triggerHandler 'tip', tip

    $tip.find('span.username').attr('data-nick', tip.from_user).text(tip.from_user).addClass getUserTypeClass(user)
    $tip.find('span.tipalert').append(document.createTextNode(' tipped ' + tip.amount + ' tokens' + (if message then ' -- ' + message else '')))

    tipSound = new Audio('cb/sounds/' + (
        switch
          when amount >= 1000 then 'huge'
          when amount >= 500 then 'large'
          when amount >= 100 then 'medium'
          when amount >= 15 then 'small'
          else
            'tiny'
      ) + '.mp3'
    )
    tipSound.volume = 0.05
    tipSound.play()

  @notice: (message = '', to_user = '', background = '#FFFFFF', foreground = '#000000', weight = 'normal', to_group = '') ->
    for message in message.split('\n')
      $notice = appendToChatList($('<div class="text"><p>')).find('p')

      $notice.append('Notice: ' + getEmoticons(message)).css({backgroundColor: background, color: foreground, fontWeight: weight})

      if to_user or to_group
        $notice.append($('<span class="__debug">').css({color: '#CCC'}).text((if to_user then ' [to_user=' + to_user + ']' else '') + (if to_group then ' [to_group=' + to_group + ']' else '')))

  @log: (message) -> appendToChatList($('<div class="text"><p>')).find('p').text('Debug: ' + message) if debug

  @error: (message, prefix = 'Error: ') -> appendToChatList($('<div class="text"><p>')).find('p').text(prefix + message)

  @addUser: (newUser) ->
    newUser = User(newUser)

    if newUser.user not in @getUsers()
      users.push(newUser)
      @changeUser(newUser.user)

      $enter = appendToChatList($('<div class="text"><p>')).find('p')
      $enter.append (if newUser.is_mod then 'Moderator ' else '')
      $enter.append('<span class="username othermessagelabel">').find('span.username').attr('data-nick', newUser.user).text(newUser.user).addClass getUserTypeClass(newUser)
      $enter.append ' has joined the room.'

      triggerHandler 'enter', newUser

  @removeUser: (user) ->
    if user isnt broadcaster and user in @getUsers()
      user = @getUser user
      triggerHandler 'leave', user

      users = $.grep(users, (_user) -> _user.user isnt user.user)
      if user.user is currentUser then @changeUser(broadcaster) else @updateUI()

      $leave = appendToChatList($('<div class="text"><p>')).find('p')
      $leave.append (if user.is_mod then 'Moderator ' else '')
      $leave.append('<span class="username othermessagelabel">').find('span.username').attr('data-nick', user.user).text(user.user).addClass getUserTypeClass(user)
      $leave.append ' has left the room.'

      return user

  @getUser       : (_user) -> $.grep(users, (user) -> user.user is _user)[0]
  @getUsers      : -> user.user for user in users
  @getCurrentUser: -> @getUser(currentUser)
  @getSlug       : -> broadcaster
  @getSubject    : -> subject
  @changeUser    : (newUser) ->
    if newUser in @getUsers()
      currentUser = newUser

      if currentUser is broadcaster
        $('#__broadcaster_panel').show()
        $('#__user_panel, #__broadcaster_panel ~ .green_button_tip').hide()
      else
        $('#__broadcaster_panel').hide()
        $('#__user_panel, #__broadcaster_panel ~ .green_button_tip').show()

      @updateUI()

  @setSubject: (_subject) ->
    if _subject isnt subject
      subject = _subject or defaultSubject

      appendToChatList($('<div class="text"><p><span class="roommessagelabel">')).find('span').text('room subject changed to "' + subject + '"')

      $('#roomtitleform').find('input[name=roomtitle]').val(subject)
      $('#roomtitle').text(subject)

  @drawPanel: (panelOptions = triggerHandler('drawPanel') or {template: null, row1_label: '', row1_value: '', row2_label: '', row2_value: '', row3_label: '', row3_value: ''}) ->
    if currentUser is broadcaster
      $('#broadcaster_panel').show()
      $('#user_panel').hide()
      if panelOptions.template
        $('#broadcaster_panel .broadcaster_panel_goal_display').show()
        $('#broadcaster_panel .broadcaster_panel_default').hide()
      else
        $('#broadcaster_panel .broadcaster_panel_default').show()
        $('#broadcaster_panel .broadcaster_panel_goal_display').hide()
    else
      $('#user_panel').show()
      $('#broadcaster_panel').hide()

      if panelOptions.template
        $('#user_panel .goal_display').show()
      else
        $('#user_panel .goal_display').hide()

    $('.tip_shell .goal_display').text('')
    if panelOptions.template
      $('.tip_shell .goal_display').append(buildPanel(panelOptions))

  @getCam: -> $.extend({}, cam)

  @setCam: ({running, message, users, addUsers, removeUsers}) ->
    cam.running = running if running isnt undefined
    cam.message = message if message isnt undefined

    if users isnt undefined
      cam.users = users
    else
      cam.users = $.merge(cam.users, addUsers) if addUsers isnt undefined
      cam.users = $.grep(cam.users, (user) -> user not in removeUsers) if removeUsers isnt undefined

    if cam.running
      $player_message = $('#player').find('> span').html('<span>Cam is Hidden</span><br><br><br>')
      for m in cam.message.split('\n')
        $player_message.append((if m then ('<span>' + m + '</span>') else '') + '<br>')

      allowed_users = cam.users.join(', ')
      $player_message.append('<br><span>' + (if allowed_users then 'Allowed users: ' + allowed_users else 'No allowed users in show.') + '</span>')
    else
      $('#player').find('> span').text('')

  @updateUI: ->
    updateUserList()
    @drawPanel()

    user = @getCurrentUser()
    $userInformation = $('#user_information')
    $userInformation.find('a.username').text(user.user)
    $userInformation.find('img').attr(icons[user.gender])
    $('#user_information span.tokencount, .tip_shell .token_balance div.tokens.tokencount, .overlay_popup.tip_popup .balance span.tokencount').html(if user.has_tokens then '&infin;' else '0')

    for app, slot in apps
      $apps_and_bots_table = $('#apps_and_bots_table')
      $appName = $apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(2)')
      $appAction = $apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(3)').html('')

      $deactivate = $('<a href="#">').text('Deactivate This App').addClass('stop_link').on('click', ((slot) -> return -> Room.deactivateApp(slot))(slot))
      $choose = $('<a href="#">').text('Choose a ' + (if slot == 0 then 'App' else 'Bot')).addClass('toolbar_popup_link').on('click', ((slot) -> return ->
        appId = prompt('Enter the App ID/URL or\nLeave empty to load from a file:')

        if appId
          match = appId.match(/chaturbate\.com\/app\/[^\/]*\/([^\/]*)\/?/)
          appId = match[1] if match

          Room.loadAppFromCB(appId, slot)
        else
          Room.loadAppFromFile(slot)

        return false)(slot)
      )
      $restart = $('<a href="/options?slot=' + slot + '">').text('Restart "' + app.name + '"').addClass('toolbar_popup_link').on('click', ((slot) -> return -> Room.activateApp(slot))(slot))

      if app.cb instanceof CB
        $appName.addClass(if slot == 0 then 'top_row_center' else 'center').removeClass('center_empty').removeClass('top_row_center_empty').text(app.name)
        $appAction.append($deactivate)
      else
        if app.script
          $appAction.append($choose)
          $appAction.append($('<span>').text(' or '))
          $appAction.append($restart)
        else
          $appAction.append($choose)

        $appName.addClass(if slot == 0 then 'top_row_center_empty' else 'center_empty').removeClass('center').removeClass('top_row_center').text('None Selected')

    return

  @init: ->
    $('body').html((index, html) -> # Show subject and room name on page
      html.replace(/{#ROOM_SUBJECT#}/g, Room.getSubject()).replace(/{#ROOM_SLUG#}/g, Room.getSlug())
    )

    $('#roomtitle').on 'click', -> # Show change subject form
      $(this).hide()
      $('#roomtitleform').show().find('input[name=roomtitle]').val(Room.getSubject()).select()
      $('#tooltip-subject').show()

      return false

    $('#roomtitleform').find('input[value=Submit]').on 'click', -> # Change subject
      Room.setSubject($('#roomtitleform').find('input[name=roomtitle]').val())

      $('#roomtitle').show()
      $('#roomtitleform').hide().find('input[name=roomtitle]').val(Room.getSubject())
      $('#tooltip-subject').hide()

      return false

    $('#roomtitleform').find('input[value=Cancel]').on 'click', -> # Cancel subject change
      $('#roomtitle').show()
      $('#roomtitleform').hide().find('input[name=roomtitle]').val(Room.getSubject())
      $('#tooltip-subject').hide()

      return false

    $('form.chat-form a.send_message_button').on 'click', -> # Send message
      $(this).closest('form').submit()

      return false

    $('form.chat-form').on 'submit', -> # Send message
      input = $(this).find('#chat_input')
      Room.message(input.val())
      input.val('')

      return false

    $('.tip_shell .overlay_popup.tip_popup form').on 'submit', -> # Send tip
      if Room.getCurrentUser().has_tokens
        Room.tip(
          $(this).find('#id_tip_amount').val(),
          $(this).find('#id_tip_msg_input').val() or $(this).find('#tip_options_select').val()
        )

        $('.tip_shell div.overlay_popup.tip_popup').hide().find('#id_tip_msg_input').val('')
      else
        alert('You do not have enough tokens.')

      return false

    $('.tip_shell .green_button_tip a.tip_button').on 'click', -> # Show tip popup
      tipOptions = triggerHandler('tipOptions')

      if tipOptions
        $('#id_tip_msg_input').prevAll('label').text(tipOptions.label)
        $('#id_tip_msg_input').replaceWith('<select name="tip_options" id="tip_options_select" style="width: 360px; height: 30px; "><option value="">-- Select One --</option>')

        for option in tipOptions.options
          $('#tip_options_select').append $('<option>').text(option.label)
      else
        $('#tip_options_select').prevAll('label').text('Include an optional message:')
        $('#tip_options_select').replaceWith('<textarea style="width: 360px; height: 30px; margin-bottom: 3px;" id="id_tip_msg_input" name="message" maxlength="255"></textarea>')

      $('.tip_shell div.overlay_popup.tip_popup').show().find('#id_tip_amount').select()

      return false

    $(document).on 'mouseup', (e) -> # Hide tip popup
      tip_popup = $('.tip_shell div.overlay_popup.tip_popup')

      if not tip_popup.is(e.target) and tip_popup.has(e.target).length is 0
        tip_popup.hide()

      return false

    $('#__users').on 'change', -> Room.changeUser $(this).val() # Change current user

    $chatList = $('#defchat').find('div.section > div.chat-holder > div > div.chat-list')
    $chatList.bind 'DOMSubtreeModified', -> # Try to keep scroll at the bottom of the chat
      if ($chatList.prop('scrollTop') + 30) > ($chatList.prop('scrollHeight') - $chatList.prop('offsetHeight'))
        $chatList.prop('scrollTop', $chatList.prop('scrollHeight'))
