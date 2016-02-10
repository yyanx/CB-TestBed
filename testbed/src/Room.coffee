class Room
  broadcaster = 'broadcaster'
  defaultSubject = broadcaster.charAt(0).toUpperCase() + broadcaster.slice(1) + "'s room"
  subject = defaultSubject
  debug = false
  apps = []

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

  getSettings = (settings_choices, callback) -> # TODO App options
    settings = {}
    for setting in settings_choices then settings[setting.name] = setting.defaultValue

    callback settings

  appendToChatList = ($node) ->
    $chatList = $('#defchat').find('div.section > div.chat-holder > div > div.chat-list').append($node)

    if $chatList.children().length > 200
      $chatList.find('> div.text:first-child').remove()

    $node

  triggerHandler = (type, obj) ->
    for cb in apps
      if cb and handler = cb.__eventsHandlers[type]
        result = handler(obj)
        obj = result if result

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

  @loadApp: (path, slot) ->
    $.ajax(
      {
        url     : path,
        dataType: 'text',
        success : (script) ->
          cb = null
          appName = if slot is 0 then 'CBApp' else 'CBBot #' + slot
          apps_and_bots_table = $('#apps_and_bots_table')

          runScript = (cb = new CB(slot)) ->
            mask = {}
            for p in Object.keys(@) then mask[p] = undefined
            mask['cb'] = cb
            mask['cbjs'] = CBJS

            (->
              `with (this) {
                eval(script)
              }`
              return
            ).call mask

            return cb

          activateApp = ->
            getSettings runScript().settings_choices, (settings) ->
              runScript(apps[slot] = cb = new CB(slot, settings)).sendNotice(appName + ' app has started.')

              apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(3) a')
              .text('Deactivate This App').addClass('stop_link').removeClass('toolbar_popup_link').attr('href', '#').off('click').on('click', deactivateApp)
              apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(2)')
              .addClass('center').removeClass('center_empty').removeClass('top_row_center_empty').text(appName)

              Room.updateUI()

            return false

          deactivateApp = ->
            if cb isnt null
              apps[slot] = cb = cb.__activated = null
              Room.loadApp(path, slot)

              return false

          apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(3) a')
          .text('Start "' + appName + '"').addClass('toolbar_popup_link').removeClass('stop_link').attr('href', '#').off('click').on('click', activateApp)
          apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(2)')
          .addClass('center_empty').removeClass('center').removeClass('top_row_center').text('None Selected')

          Room.updateUI()
      }
    )

  @message: (message) ->
    if message is '/debug'
      $debug = appendToChatList($('<div class="text"><p>'))
      $debug.find('p').text('Debug mode ' + if not debug then 'enabled. Type /debug again to disable.' else 'disabled.')
      debug = not debug

    else if match = message.match(/^\/tip(?:\s([0-9]+)(?:\s(.*))?)?/)
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

    (
      new Audio('cb/sounds/' + (
          switch
            when amount >= 1000 then 'huge'
            when amount >= 500 then 'large'
            when amount >= 100 then 'medium'
            when amount >= 15 then 'small'
            else
              'tiny'
        ) + '.mp3'
      )
    ).play()

  @notice: (message = '', to_user = '', background = '#FFFFFF', foreground = '#000000', weight = 'normal', to_group = '') ->
    for message in message.split('\n')
      $notice = appendToChatList($('<div class="text"><p>')).find('p')

      $notice.append('Notice: ' + getEmoticons(message)).css({backgroundColor: background, color: foreground, fontWeight: weight})

      if to_user or to_group
        $notice.append($('<span class="__debug">').css({color: '#CCC'}).text((if to_user then ' [to_user=' + to_user + ']' else '') + (if to_group then ' [to_group=' + to_group + ']' else '')))

  @log: (message) -> appendToChatList($('<div class="text"><p>')).find('p').text('Debug: ' + message) if debug

  @addUser: (newUser) ->
    newUser = User(newUser)

    if newUser.user not in @getUsers()
      users.push(newUser)
      @changeUser(newUser.user)

      $enter = appendToChatList($('<div class="text"><p>')).find('p')
      $enter.append (if newUser.is_mod then 'Moderator ' else '')
      $enter.append('<span class="username othermessagelabel">').find('span.username').attr('data-nick', newUser.user).text(newUser.user).addClass getUserTypeClass(newUser)
      $enter.append ' has joined the room.'
      $enter.append($('<span class="__debug">').css({color: '#CCC'}).text(' [to_user=' + broadcaster + ']')) if newUser.has_tokens and not newUser.is_mod

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
      $leave.append($('<span class="__debug">').css({color: '#CCC'}).text(' [to_user=' + broadcaster + ']')) if user.has_tokens and not user.is_mod

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

  @drawPanel: (panelOptions = triggerHandler('drawPanel') or {}) ->
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

    return

  @init: ->
    $('body').html((index, html) -> # Show subject and room name on page
      html.replace(/{#ROOM_SUBJECT#}/g, Room.getSubject()).replace(/{#ROOM_SLUG#}/g, Room.getSlug())
    )

    $('#roomtitle').on 'click', -> # Show change subject form
      $(this).hide();
      $('#roomtitleform').show().find('input[name=roomtitle]').val(Room.getSubject()).select()
      $('#tooltip-subject').show()

      return false

    $('#roomtitleform').find('input[value=Submit]').on 'click', -> # Change subject
      Room.setSubject($('#roomtitleform').find('input[name=roomtitle]').val())

      $('#roomtitle').show();
      $('#roomtitleform').hide().find('input[name=roomtitle]').val(Room.getSubject())
      $('#tooltip-subject').hide()

      return false

    $('#roomtitleform').find('input[value=Cancel]').on 'click', -> # Cancel subject change
      $(this).hide().find('input[name=roomtitle]').val(Room.getSubject())
      $('#roomtitle').show();
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
