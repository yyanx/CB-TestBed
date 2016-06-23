var CB, CBJS, Room,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

CB = (function() {
  CB.prototype.__bot = false;

  CB.prototype.__activated = false;

  CB.prototype.__eventsHandlers = {};


  /**
   * @param {Number} slot
   * @param {Object} [settings]
   */

  function CB(slot, settings) {
    if (slot == null) {
      slot = 0;
    }
    if (slot !== 0) {
      this.__bot = true;
    }
    this.__eventsHandlers = {};
    this.room_slug = Room.getSlug();
    this.slot = slot;
    if (settings) {
      this.settings = settings;
      this.__activated = true;
    } else {
      this.settings = {};
    }
  }


  /**
   * Changes the room subject.
   *
   * @param {string} new_subject
   * @see This function is only available to apps, not bots.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.changeRoomSubject.html|cb.changeRoomSubject}
   */

  CB.prototype.changeRoomSubject = function(new_subject) {
    if (this.__activated && !this.__bot) {
      return Room.setSubject(new_subject);
    }
  };


  /**
   * Requests that all users reload the panel (the HTML info area below the cam). The contents of the panel are controlled by {@link onDrawPanel}.
   *
   * @see This function is only available to apps, not bots.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.drawPanel.html|cb.drawPanel}
   */

  CB.prototype.drawPanel = function() {
    if (this.__activated && !this.__bot) {
      return Room.drawPanel();
    }
  };


  /**
   * Hides the cam feed from viewers and shows them a custom message. You can optionally pass in an array of usernames of whom you’d like to be able to view the cam.
   *
   * @param {string} message
   * @param {Array} allowed_users
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_start = function(message, allowed_users) {
    if (this.__activated) {
      return Room.setCam({
        running: true,
        message: message,
        users: allowed_users
      });
    }
  };


  /**
   * Stops the camera from being hidden from viewers, returning the broadcaster to public broadcasting.
   *
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_stop = function() {
    if (this.__activated) {
      return Room.setCam({
        running: false
      });
    }
  };


  /**
   * Add an array of usernames to allow viewing of the cam while it is hidden to others. You can use this before, during, or after you start/stop limiting the cam.
   *
   * @param {Array} allowed_users
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_addUsers = function(allowed_users) {
    if (this.__activated) {
      return Room.setCam({
        addUsers: allowed_users
      });
    }
  };


  /**
   * Remove an array of usernames to no longer be able to view the cam.
   *
   * @param {Array} removed_users
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_removeUsers = function(removed_users) {
    if (this.__activated) {
      return Room.setCam({
        removeUsers: removed_users
      });
    }
  };


  /**
   * Remove all viewers from being able to view the cam.
   *
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_removeAllUsers = function() {
    if (this.__activated) {
      return Room.setCam({
        users: []
      });
    }
  };


  /**
   * Check if a particular username is in the list of those allowed to view the cam.
   *
   * @param {string} user
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_userHasAccess = function(user) {
    return indexOf.call(Room.getCam().users, user) >= 0;
  };


  /**
   * Get an array of the usernames that are allowed to view the cam.
   *
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_allUsersWithAccess = function() {
    return Room.getCam().users;
  };


  /**
   * Check if the cam is viewable by those not in the allowed list.
   *
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.limitCam.html|cb.limitCam}
   */

  CB.prototype.limitCam_isRunning = function() {
    return Room.getCam().running;
  };


  /**
   * Adds a debug message to the chat. These log messages are broadcast to the chat room, but you must enable debug mode to see them.
   * To enable or disable debug mode, type /debug into chat.
   *
   * @param {string} message
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.log.html|cb.log}
   */

  CB.prototype.log = function(message) {
    if (this.__activated) {
      return Room.log(message);
    }
  };


  /**
   * Return data needed to display the info panel for a user.
   * The return value is a key-value set with a template key. Depending on the template chosen, additional keys should be passed in.
   * For more information, see {@link https://chaturbate.com/apps/docs/api/cb.onDrawPanel.html#available-templates|Available Templates}.
   *
   * @param {Function} func
   * @see This function is only available to apps, not bots.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onDrawPanel.html|cb.onDrawPanel}
   */

  CB.prototype.onDrawPanel = function(func) {
    if (!this.__bot && func instanceof Function) {
      return this.__eventsHandlers.drawPanel = func;
    }
  };


  /**
   * Receive a notification when a registered member enters the room.
   *
   * @param {Function} func - The func argument should be a function that receives 1 argument itself, user.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onEnter.html|cb.onEnter}
   */

  CB.prototype.onEnter = function(func) {
    if (func instanceof Function) {
      return this.__eventsHandlers.enter = func;
    }
  };


  /**
   * Receive a notification when a registered member leaves the room.
   *
   * @param {Function} func - The func argument should be a function that receives 1 argument itself, user.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onLeave.html|cb.onLeave}
   */

  CB.prototype.onLeave = function(func) {
    if (func instanceof Function) {
      return this.__eventsHandlers.leave = func;
    }
  };


  /**
   * Receive a notification when a message is sent.
   *
   * Your app can manipulate the message.
   * You must return the original message object.
   *
   * @param {Function} func - The func argument should be a function that receives 1 argument itself, message.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onMessage.html|cb.onMessage}
   */

  CB.prototype.onMessage = function(func) {
    if (func instanceof Function) {
      return this.__eventsHandlers.message = func;
    }
  };


  /**
   * Receive a notification when a tip is sent.
   *
   * @param {Function} func - The func argument should be a function that receives 1 argument itself, tip.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.onTip.html|cb.onTip}
   */

  CB.prototype.onTip = function(func) {
    if (func instanceof Function) {
      return this.__eventsHandlers.tip = func;
    }
  };


  /**
   * A variable that contains the name of the current room.
   *
   * @type {string}
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.room_slug.html|cb.room_slug}
   *
   * @example
   * // This can be used to determine if a message is being sent by the broadcaster.
   * if (msg['user'] == cb.room_slug) { cb.chatNotice("Message sent by broadcaster") }
   */

  CB.prototype.room_slug = '';


  /**
   * A variable that contains the slot which the app is running.
   *
   * @type {Number}
   */

  CB.prototype.slot = 0;


  /**
   * Send a message to the room.
   *
   * You can use a \n inside the message to send a multi-line notice.
   * You may use :emoticons in the notice.
   *
   * @param {string} message
   * @param {string} [to_user]
   * @param {string} [background] - Only HTML color codes (such as #FF0000)
   * @param {string} [foreground] - Only HTML color codes (such as #FF0000)
   * @param {"normal"|"bold"|"bolder"} [weight]
   * @param {"red"|"green"|"darkblue"|"lightpurple"|"darkpurple"|"lightblue"} [to_group]
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.sendNotice.html|cb.sendNotice}
   */

  CB.prototype.sendNotice = function(message, to_user, background, foreground, weight, to_group) {
    if (this.__activated) {
      return Room.notice(message, to_user, background, foreground, weight, to_group);
    }
  };


  /**
   * Alias to sendNotice
   *
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.chatNotice.html|cb.chatNotice}
   * @deprecated
   */

  CB.prototype.chatNotice = CB.prototype.sendNotice;


  /*
   * Calls a function or executes a code snippet after a specified number of milliseconds.
   *
   * @param {Function} func
   * @param {Number} msecs
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.setTimeout.html|cb.setTimeout}
   */

  CB.prototype.setTimeout = function(func, msecs) {
    if (this.__activated) {
      return window.setTimeout(func, msecs);
    }
  };


  /**
   * Set this variable in order to have a form filled out by the broadcaster before the app is launched.
   *
   * For each name in cb.settings_choices, there will be a value loaded in cb.settings.
   *
   * @type {Array}
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.settings_choices.html|cb.settings_choices}
   */

  CB.prototype.settings_choices = [];


  /**
   * For each name in cb.settings_choices, there will be a value loaded in cb.settings.
   *
   * @type {Object}
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.settings_choices.html|cb.settings_choices}
   */

  CB.prototype.settings = {};


  /**
   * When users send a tip, present them with a list of messages to send with their tip.
   * These messages can be received and processed later by {@link onTip}.
   *
   * @param {Function} func
   * @see This function is only available to apps, not bots.
   * @see Apps 1.0 documentation {@link https://chaturbate.com/apps/docs/api/cb.tipOptions.html|cb.tipOptions}
   */

  CB.prototype.tipOptions = function(func) {
    if (!this.__bot && func instanceof Function) {
      return this.__eventsHandlers.tipOptions = func;
    }
  };

  return CB;

})();

CBJS = (function() {
  function CBJS() {}


  /**
   * Returns true if array contains at least once instance of object.
   *
   * @param {Array} array
   * @param {Object} object
   */

  CBJS.arrayContains = function(array, object) {
    return indexOf.call(array, object) >= 0;
  };


  /**
   * Removes all instances of object from array and returns the new array.
   *
   * @param {Array} array
   * @param {Object} object
   */

  CBJS.arrayRemove = function(array, object) {
    return array.filter(function(obj) {
      return obj !== object;
    });
  };


  /**
   * Joins all elements of an array into a string.
   *
   * @param {Array} array
   * @param {string} separator
   */

  CBJS.arrayJoin = function(array, separator) {
    return array.join(separator);
  };

  return CBJS;

})();

Room = (function() {
  var Message, Tip, User, appendToChatList, apps, broadcaster, buildPanel, cam, currentUser, debug, defaultSubject, getEmoticons, getSettings, getUserTypeClass, icons, loadScript, subject, triggerHandler, updateUserList, users;

  function Room() {}

  broadcaster = 'broadcaster';

  defaultSubject = broadcaster.charAt(0).toUpperCase() + broadcaster.slice(1) + "'s room";

  subject = defaultSubject;

  debug = false;

  apps = [{}, {}, {}, {}];

  cam = {
    running: false,
    message: '',
    users: []
  };

  icons = {
    m: {
      src: 'cb/images/ico-male-blue.gif',
      alt: 'Male Icon'
    },
    f: {
      src: 'cb/images/ico-female-blue.gif',
      alt: 'Female Icon'
    },
    c: {
      src: 'cb/images/ico-couple-blue.gif',
      alt: 'Couples Icon'
    },
    s: {
      src: 'cb/images/ico-shemale-blue.gif',
      alt: 'Transsexual Icon'
    }
  };

  Message = function(arg) {
    var c, f, m;
    c = arg.c, m = arg.m, f = arg.f;
    return {
      c: c || '#494949',
      m: m || '',
      f: f || 'default'
    };
  };

  User = function(arg) {
    var gender, has_tokens, in_fanclub, is_mod, tipped_alot_recently, tipped_recently, tipped_tons_recently, user;
    user = arg.user, in_fanclub = arg.in_fanclub, has_tokens = arg.has_tokens, is_mod = arg.is_mod, tipped_recently = arg.tipped_recently, tipped_alot_recently = arg.tipped_alot_recently, tipped_tons_recently = arg.tipped_tons_recently, gender = arg.gender;
    return {
      user: user || '',
      in_fanclub: in_fanclub || false,
      has_tokens: has_tokens || false,
      is_mod: is_mod || false,
      tipped_recently: tipped_recently || false,
      tipped_alot_recently: tipped_alot_recently || false,
      tipped_tons_recently: tipped_tons_recently || false,
      gender: gender || ''
    };
  };

  Tip = function(arg) {
    var amount, from_user, from_user_gender, from_user_has_tokens, from_user_in_fanclub, from_user_is_mod, from_user_tipped_alot_recently, from_user_tipped_recently, from_user_tipped_tons_recently, message, to_user;
    amount = arg.amount, message = arg.message, to_user = arg.to_user, from_user = arg.from_user, from_user_in_fanclub = arg.from_user_in_fanclub, from_user_has_tokens = arg.from_user_has_tokens, from_user_is_mod = arg.from_user_is_mod, from_user_tipped_recently = arg.from_user_tipped_recently, from_user_tipped_alot_recently = arg.from_user_tipped_alot_recently, from_user_tipped_tons_recently = arg.from_user_tipped_tons_recently, from_user_gender = arg.from_user_gender;
    return {
      amount: amount || 0,
      message: message || '',
      to_user: to_user || '',
      from_user: from_user || '',
      from_user_in_fanclub: from_user_in_fanclub || false,
      from_user_has_tokens: from_user_has_tokens || false,
      from_user_is_mod: from_user_is_mod || false,
      from_user_tipped_recently: from_user_tipped_recently || false,
      from_user_tipped_alot_recently: from_user_tipped_alot_recently || false,
      from_user_tipped_tons_recently: from_user_tipped_tons_recently || false,
      from_user_gender: from_user_gender || ''
    };
  };

  currentUser = broadcaster;

  users = [
    User({
      user: broadcaster,
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'grey',
      has_tokens: false,
      gender: 'm'
    }), User({
      user: 'hasTokens',
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'fan',
      in_fanclub: true,
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'mod',
      is_mod: true,
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'tippedRecently',
      tipped_recently: true,
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'tippedAlotRecently',
      tipped_alot_recently: true,
      has_tokens: true,
      gender: 'm'
    }), User({
      user: 'tippedTonsRecently',
      tipped_tons_recently: true,
      has_tokens: true,
      gender: 'm'
    })
  ];

  getSettings = function(settings_choices, slot, callback) {
    var app, appOptions, buildSettingLine, j, len, setting;
    app = apps[slot];
    buildSettingLine = function(setting, value) {
      var $input, $line, $select, choice, i;
      if (value == null) {
        value = setting.defaultValue || setting["default"];
      }
      $line = $('<tr><th><label></label></th><td colspan="2"></td></tr>');
      if (setting.required !== false) {
        $line.find('th').addClass('requiredfield');
      }
      $line.find('label').attr('for', 'id_' + setting.name).text(setting.label + (setting.type !== 'choice' ? ':' : ''));
      switch (setting.type) {
        case 'int':
          $input = $('<input type="number">').attr({
            id: 'id_' + setting.name,
            name: setting.name,
            min: setting.minValue !== void 0 ? setting.minValue : void 0,
            max: setting.maxValue !== void 0 ? setting.maxValue : void 0
          });
          $input.val(value);
          $line.find('td').append($input);
          break;
        case 'str':
          $input = $('<input type="text">').attr({
            id: 'id_' + setting.name,
            name: setting.name,
            minLength: setting.minLength !== void 0 ? setting.minLength : void 0,
            maxLength: setting.maxLength !== void 0 ? setting.maxLength : void 0
          });
          $input.val(value);
          $line.find('td').append($input);
          break;
        case 'choice':
          $select = $('<select>').attr({
            id: 'id_' + setting.name,
            name: setting.name
          });
          while (choice = setting['choice' + (++i || (i = 1))]) {
            $select.append($('<option>').val(choice).text(choice).attr({
              selected: choice === value ? 'selected' : void 0
            }));
          }
          $line.find('td').append($select);
      }
      return $line;
    };
    if (settings_choices && settings_choices instanceof Array && settings_choices.length > 0) {
      appOptions = open('', 'cb-testbed-app' + slot, 'width=768,height=576,location=0,menubar=0,status=0,toolbar=0', true);
      if (appOptions) {
        if (appOptions.location.host === '') {
          appOptions.document.write('<html><head><title>' + app.name + ' Options</title><link rel="stylesheet" href="cb/css/settings.css" type="text/css"></head><body><form id="app_start_form"><table><tbody></tbody></table><input type="submit"></form></body></html>');
          $(appOptions.document.body).find('input[type=submit]').val('Start ' + (slot === 0 ? 'App' : 'Bot'));
          for (j = 0, len = settings_choices.length; j < len; j++) {
            setting = settings_choices[j];
            $(appOptions.document.body).find('tbody').append(buildSettingLine(setting, app.settings[setting.name]));
          }
          $(appOptions.document.body).find('form').on('submit', function() {
            app.settings = $(this).serializeArray().reduce((function(settings, setting) {
              settings[setting.name] = setting.value;
              return settings;
            }), {});
            callback($.extend({}, app.settings));
            appOptions.close();
            return false;
          });
        }
        return appOptions.focus();
      } else {
        return alert('Allow pop-ups from this page to view the options.');
      }
    } else {
      return callback({});
    }
  };

  appendToChatList = function($node) {
    var $chatList;
    $chatList = $('#defchat').find('div.section > div.chat-holder > div > div.chat-list').append($node);
    if ($chatList.children().length > 200) {
      $chatList.find('> div.text:first-child').remove();
    }
    return $node;
  };

  triggerHandler = function(type, obj) {
    var app, e, error, handler, j, len, ref, result;
    ref = apps.slice().reverse();
    for (j = 0, len = ref.length; j < len; j++) {
      app = ref[j];
      if (app.cb instanceof CB && app.cb.__activated && (handler = app.cb.__eventsHandlers[type])) {
        try {
          result = handler(obj);
          if (result && (type !== 'message' || (result instanceof Object && result.m !== void 0))) {
            obj = result;
          }
        } catch (error) {
          e = error;
          Room.error(e.message, 'An error occurred: ');
          Room.deactivateApp(app.cb.slot);
        }
      }
    }
    return obj;
  };

  getEmoticons = function(message) {
    return message.replace(/(^|\s):([A-Za-z0-9_]+)/g, '$1<img src="cb/emoticons/$2.jpg" title=":$2" onerror="$(this).replaceWith(\':$2\')">');
  };

  getUserTypeClass = function(user) {
    switch (false) {
      case user.user !== broadcaster:
        return 'hostmessagelabel';
      case !user.is_mod:
        return 'moderatormessagelabel';
      case !user.in_fanclub:
        return 'fanclubmessagelabel';
      case !user.tipped_tons_recently:
        return 'tippedtonsrecentlymessagelabel';
      case !user.tipped_alot_recently:
        return 'tippedalotrecentlymessagelabel';
      case !user.tipped_recently:
        return 'tippedrecentlymessagelabel';
      case !user.has_tokens:
        return 'hastokensmessagelabel';
      default:
        return '';
    }
  };

  buildPanel = function(panelOptions) {
    var $row1, $row2, $row3, $table;
    $table = $('<table class="goal_display_table panel"><tbody>');
    $row1 = $('<tr class="dark_blue">');
    $row2 = $('<tr class="dark_light_blue">');
    $row3 = $('<tr class="dark_blue">');
    $table.find('tbody').append($row1, $row2, $row3);
    switch (panelOptions.template) {
      case '3_rows_of_labels':
        $table.removeClass('panel');
        $row1.append($('<th>').append($('<div class="counter_label_green">').append(panelOptions.row1_label)));
        $row1.append($('<td class="data">').append(panelOptions.row1_value));
        $row2.append($('<th>').append($('<div class="counter_label">').append(panelOptions.row2_label)));
        $row2.append($('<td class="data">').append(panelOptions.row2_value));
        $row3.append($('<th>').append($('<div class="counter_label">').append(panelOptions.row3_label)));
        $row3.append($('<td class="data">').append(panelOptions.row3_value));
        break;
      case '3_rows_11_21_31':
        $table.addClass('table_3_rows_11_21_31');
        $row1.append($('<td class="data center">').append($('<strong>').append(panelOptions.row1_value)));
        $row2.append($('<td class="data center">').append(panelOptions.row2_value));
        $row3.append($('<td class="data center">').append(panelOptions.row3_value));
        break;
      case '3_rows_12_21_31':
        $row1.append($('<th>').append($('<div class="counter_label">').append(panelOptions.row1_label)));
        $row1.append($('<td class="data">').append(panelOptions.row1_value));
        $row2.append($('<td colspan="2" class="data center">').append(panelOptions.row2_value));
        $row3.append($('<td colspan="2" class="data center">').append(panelOptions.row3_value));
        break;
      case '3_rows_12_22_31':
        $row1.append($('<th>').append($('<div class="counter_label">').append(panelOptions.row1_label)));
        $row1.append($('<td class="data">').append(panelOptions.row1_value));
        $row2.append($('<th>').append($('<div class="counter_label">').append(panelOptions.row2_label)));
        $row2.append($('<td class="data">').append(panelOptions.row2_value));
        $row3.append($('<td colspan="2" class="data center">').append(panelOptions.row3_value));
        break;
      default:
        return 'App Error: Template "' + panelOptions.template + '" is missing.';
    }
    return $table;
  };

  updateUserList = function() {
    var $__users, $_temp, _user, color, j, len, ref;
    $__users = $('#__users').text('');
    ref = Room.getUsers();
    for (j = 0, len = ref.length; j < len; j++) {
      _user = ref[j];
      $('body').append($_temp = $('<div class="chat-list"><span class="' + getUserTypeClass(Room.getUser(_user)) + '">').hide());
      color = $_temp.find('span').css('color');
      $_temp.remove();
      $__users.append($('<option>').text(_user).css({
        color: color
      }));
    }
    $__users.val(currentUser).css({
      color: $__users.find(":selected").css('color')
    });
    return $('.chat-box .buttons span.usercount').text(Room.getUsers().length);
  };

  loadScript = function(arg, deactivateCallback) {
    var app, defaultSettings, name, script, slot;
    script = arg.script, slot = arg.slot, name = arg.name, defaultSettings = arg.defaultSettings;
    if (script) {
      Room.deactivateApp(slot);
      app = apps[slot] = {};
      app.name = name || (slot === 0 ? 'CBApp' : 'CBBot #' + slot);
      app.script = script;
      app.settings = defaultSettings || {};
      app.deactivateCallback = deactivateCallback;
    }
    return Room.updateUI();
  };

  Room.activateApp = function(slot) {
    var app, runScript;
    this.deactivateApp(slot);
    app = apps[slot];
    runScript = function(cb) {
      var e, error, j, len, mask, p, ref;
      if (cb == null) {
        cb = new CB(slot);
      }
      mask = {};
      ref = Object.keys(this);
      for (j = 0, len = ref.length; j < len; j++) {
        p = ref[j];
        mask[p] = void 0;
      }
      mask['cb'] = cb;
      mask['cbjs'] = CBJS;
      try {
        (function() {
          with (this) {
            eval(app.script)
          };
        }).call(mask);
      } catch (error) {
        e = error;
        if (cb.__activated) {
          Room.error('App Error: ' + e.message);
          Room.deactivateApp(cb.slot);
        }
      }
      return cb;
    };
    getSettings(runScript().settings_choices, slot, function(settings) {
      runScript(app.cb = new CB(slot, settings)).sendNotice(app.name + ' app has started.');
      return Room.updateUI();
    });
    return false;
  };

  Room.deactivateApp = function(slot) {
    var app;
    app = apps[slot];
    if (app && app.cb instanceof CB) {
      app.cb = app.cb.__activated = null;
      if (app.deactivateCallback instanceof Function) {
        app.deactivateCallback(app);
      }
    }
    this.updateUI();
    return false;
  };

  Room.loadApp = function(path, slot, defaultSettings) {
    $.ajax({
      url: path,
      dataType: 'text',
      success: function(script) {
        return loadScript({
          script: script,
          slot: slot,
          defaultSettings: defaultSettings
        }, function(app) {
          return Room.loadApp(path, slot, app.settings);
        });
      }
    });
  };

  Room.loadAppFromCB = function(name, slot) {
    $.ajax({
      url: 'https://cors-anywhere.herokuapp.com/https://chaturbate.com/apps/sourcecode/' + name + '/?slot=' + slot,
      dataType: 'text',
      success: function(data) {
        var $appPage, script;
        $appPage = $(data.replace(/src="[^"]*"/g, ''));
        script = $appPage.find('textarea.form_sourcecode').text();
        name = $appPage.find('div#app_title').text().trim();
        return loadScript({
          script: script,
          slot: slot,
          name: name
        });
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.error(jqXHR, textStatus, errorThrown);
        return alert('Failed to load the App "' + name + '".\nError: ' + errorThrown);
      }
    });
  };

  Room.loadAppFromFile = function(slot) {
    $("#app_js_file").off('change').on('change', function(e) {
      var file, fileReader;
      file = e.target.files[0];
      if (file) {
        fileReader = new FileReader;
        fileReader.addEventListener('load', function(e) {
          var script;
          script = e.target.result;
          if (script) {
            return loadScript({
              script: script,
              slot: slot
            });
          }
        });
        fileReader.readAsText(file);
        return $(this).replaceWith($('<input id="app_js_file" type="file" accept="application/javascript"/>').hide());
      }
    }).trigger('click');
  };

  Room.message = function(message) {
    var $debug, $message, $tip_amount, $tip_msg_input, $tip_popup, amount, match;
    if (message === '/debug') {
      $debug = appendToChatList($('<div class="text"><p>'));
      $debug.find('p').text('Debug mode ' + (!debug ? 'enabled. Type /debug again to disable.' : 'disabled.'));
      debug = !debug;
    } else if (match = message.match(/^\/tip(?:\s(?:([0-9]+)(?:\s(.*))?)?)?$/)) {
      if (currentUser !== broadcaster) {
        amount = match[1];
        message = match[2];
        $tip_popup = $('.tip_shell div.overlay_popup.tip_popup');
        $tip_amount = $tip_popup.find('#id_tip_amount');
        $tip_msg_input = $tip_popup.find('#id_tip_msg_input');
        if (amount = parseInt(amount)) {
          $tip_amount.val(amount);
        }
        if (message) {
          $tip_msg_input.val(message);
        }
        $tip_popup.show();
        $tip_amount.select();
      }
    } else if (message) {
      $message = appendToChatList($('<div class="text"><p><span class="username messagelabel">'));
      message = $.extend({}, this.getCurrentUser(), Message({
        m: message
      }));
      message = triggerHandler('message', message);
      $message.css({
        color: message.c,
        fontFamily: message.f !== 'default' ? message.f : void 0
      });
      $message.find('span.username').attr('data-nick', message.user).text(message.user + ':').addClass(getUserTypeClass(message));
      $message.find('p').append(getEmoticons(message.m));
      if (message['X-Spam']) {
        $message.find('p').append($('<span class="__debug">').css({
          color: '#CCC'
        }).text(' [hidden]'));
      }
    }
  };

  Room.tip = function(amount, message) {
    var $tip, tip, tipSound, user;
    user = this.getCurrentUser();
    tip = Tip({
      amount: parseInt(amount),
      message: message,
      to_user: broadcaster,
      from_user: user.user,
      from_user_in_fanclub: user.in_fanclub,
      from_user_has_tokens: user.has_tokens,
      from_user_is_mod: user.is_mod,
      from_user_tipped_recently: user.tipped_recently,
      from_user_tipped_alot_recently: user.tipped_alot_recently,
      from_user_tipped_tons_recently: user.tipped_tons_recently,
      from_user_gender: user.gender
    });
    $tip = appendToChatList($('<div class="text"><p><span class="tipalert"><span class="username othermessagelabel">'));
    triggerHandler('tip', tip);
    $tip.find('span.username').attr('data-nick', tip.from_user).text(tip.from_user).addClass(getUserTypeClass(user));
    $tip.find('span.tipalert').append(document.createTextNode(' tipped ' + tip.amount + ' tokens' + (message ? ' -- ' + message : '')));
    tipSound = new Audio('cb/sounds/' + ((function() {
      switch (false) {
        case !(amount >= 1000):
          return 'huge';
        case !(amount >= 500):
          return 'large';
        case !(amount >= 100):
          return 'medium';
        case !(amount >= 15):
          return 'small';
        default:
          return 'tiny';
      }
    })()) + '.mp3');
    tipSound.volume = 0.05;
    return tipSound.play();
  };

  Room.notice = function(message, to_user, background, foreground, weight, to_group) {
    var $notice, j, len, ref, results;
    if (message == null) {
      message = '';
    }
    if (to_user == null) {
      to_user = '';
    }
    if (background == null) {
      background = '#FFFFFF';
    }
    if (foreground == null) {
      foreground = '#000000';
    }
    if (weight == null) {
      weight = 'normal';
    }
    if (to_group == null) {
      to_group = '';
    }
    ref = message.split('\n');
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      message = ref[j];
      $notice = appendToChatList($('<div class="text"><p><span>')).find('span');
      $notice.append('Notice: ' + getEmoticons(message)).css({
        backgroundColor: background,
        color: foreground,
        fontWeight: weight
      });
      if (to_user || to_group) {
        results.push($notice.parent().append($('<span class="__debug">').css({
          color: '#CCC'
        }).text((to_user ? ' [to_user=' + to_user + ']' : '') + (to_group ? ' [to_group=' + to_group + ']' : ''))));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Room.log = function(message) {
    if (debug) {
      return appendToChatList($('<div class="text"><p>')).find('p').text('Debug: ' + message);
    }
  };

  Room.error = function(message, prefix) {
    if (prefix == null) {
      prefix = 'Error: ';
    }
    return appendToChatList($('<div class="text"><p>')).find('p').text(prefix + message);
  };

  Room.addUser = function(newUser) {
    var $enter, ref;
    newUser = User(newUser);
    if (ref = newUser.user, indexOf.call(this.getUsers(), ref) < 0) {
      users.push(newUser);
      this.changeUser(newUser.user);
      $enter = appendToChatList($('<div class="text"><p>')).find('p');
      $enter.append((newUser.is_mod ? 'Moderator ' : ''));
      $enter.append('<span class="username othermessagelabel">').find('span.username').attr('data-nick', newUser.user).text(newUser.user).addClass(getUserTypeClass(newUser));
      $enter.append(' has joined the room.');
      return triggerHandler('enter', newUser);
    }
  };

  Room.removeUser = function(user) {
    var $leave;
    if (user !== broadcaster && indexOf.call(this.getUsers(), user) >= 0) {
      user = this.getUser(user);
      triggerHandler('leave', user);
      users = $.grep(users, function(_user) {
        return _user.user !== user.user;
      });
      if (user.user === currentUser) {
        this.changeUser(broadcaster);
      } else {
        this.updateUI();
      }
      $leave = appendToChatList($('<div class="text"><p>')).find('p');
      $leave.append((user.is_mod ? 'Moderator ' : ''));
      $leave.append('<span class="username othermessagelabel">').find('span.username').attr('data-nick', user.user).text(user.user).addClass(getUserTypeClass(user));
      $leave.append(' has left the room.');
      return user;
    }
  };

  Room.getUser = function(_user) {
    return $.grep(users, function(user) {
      return user.user === _user;
    })[0];
  };

  Room.getUsers = function() {
    var j, len, results, user;
    results = [];
    for (j = 0, len = users.length; j < len; j++) {
      user = users[j];
      results.push(user.user);
    }
    return results;
  };

  Room.getCurrentUser = function() {
    return this.getUser(currentUser);
  };

  Room.getSlug = function() {
    return broadcaster;
  };

  Room.getSubject = function() {
    return subject;
  };

  Room.changeUser = function(newUser) {
    if (indexOf.call(this.getUsers(), newUser) >= 0) {
      currentUser = newUser;
      if (currentUser === broadcaster) {
        $('#__broadcaster_panel').show();
        $('#__user_panel, #__broadcaster_panel ~ .green_button_tip').hide();
      } else {
        $('#__broadcaster_panel').hide();
        $('#__user_panel, #__broadcaster_panel ~ .green_button_tip').show();
      }
      return this.updateUI();
    }
  };

  Room.setSubject = function(_subject) {
    if (_subject !== subject) {
      subject = _subject || defaultSubject;
      appendToChatList($('<div class="text"><p><span class="roommessagelabel">')).find('span').text('room subject changed to "' + subject + '"');
      $('#roomtitleform').find('input[name=roomtitle]').val(subject);
      return $('#roomtitle').text(subject);
    }
  };

  Room.drawPanel = function(panelOptions) {
    if (panelOptions == null) {
      panelOptions = triggerHandler('drawPanel', this.getCurrentUser()) || {
        template: null,
        row1_label: '',
        row1_value: '',
        row2_label: '',
        row2_value: '',
        row3_label: '',
        row3_value: ''
      };
    }
    if (currentUser === broadcaster) {
      $('#broadcaster_panel').show();
      $('#user_panel').hide();
      if (panelOptions.template) {
        $('#broadcaster_panel .broadcaster_panel_goal_display').show();
        $('#broadcaster_panel .broadcaster_panel_default').hide();
      } else {
        $('#broadcaster_panel .broadcaster_panel_default').show();
        $('#broadcaster_panel .broadcaster_panel_goal_display').hide();
      }
    } else {
      $('#user_panel').show();
      $('#broadcaster_panel').hide();
      if (panelOptions.template) {
        $('#user_panel .goal_display').show();
      } else {
        $('#user_panel .goal_display').hide();
      }
    }
    $('.tip_shell .goal_display').text('');
    if (panelOptions.template) {
      return $('.tip_shell .goal_display').append(buildPanel(panelOptions));
    }
  };

  Room.getCam = function() {
    return $.extend({}, cam);
  };

  Room.setCam = function(arg) {
    var $player_message, addUsers, allowed_users, j, len, m, message, ref, removeUsers, running, users;
    running = arg.running, message = arg.message, users = arg.users, addUsers = arg.addUsers, removeUsers = arg.removeUsers;
    if (running !== void 0) {
      cam.running = running;
    }
    if (message !== void 0) {
      cam.message = message;
    }
    if (users !== void 0) {
      cam.users = users;
    } else {
      if (addUsers !== void 0) {
        cam.users = $.merge(cam.users, addUsers);
      }
      if (removeUsers !== void 0) {
        cam.users = $.grep(cam.users, function(user) {
          return indexOf.call(removeUsers, user) < 0;
        });
      }
    }
    if (cam.running) {
      $player_message = $('#player').find('> span').html('<span>Cam is Hidden</span><br><br><br>');
      ref = cam.message.split('\n');
      for (j = 0, len = ref.length; j < len; j++) {
        m = ref[j];
        $player_message.append((m ? '<span>' + m + '</span>' : '') + '<br>');
      }
      allowed_users = cam.users.join(', ');
      return $player_message.append('<br><span>' + (allowed_users ? 'Allowed users: ' + allowed_users : 'No allowed users in show.') + '</span>');
    } else {
      return $('#player').find('> span').text('');
    }
  };

  Room.updateUI = function() {
    var $appAction, $appName, $apps_and_bots_table, $choose, $deactivate, $restart, $userInformation, app, j, len, slot, user;
    updateUserList();
    this.drawPanel();
    user = this.getCurrentUser();
    $userInformation = $('#user_information');
    $userInformation.find('a.username').text(user.user);
    $userInformation.find('img').attr(icons[user.gender]);
    $('#user_information span.tokencount, .tip_shell .token_balance div.tokens.tokencount, .overlay_popup.tip_popup .balance span.tokencount').html(user.has_tokens ? '&infin;' : '0');
    for (slot = j = 0, len = apps.length; j < len; slot = ++j) {
      app = apps[slot];
      $apps_and_bots_table = $('#apps_and_bots_table');
      $appName = $apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(2)');
      $appAction = $apps_and_bots_table.find('tr:nth-child(' + (slot + 1) + ') td:nth-child(3)').html('');
      $deactivate = $('<a href="#">').text('Deactivate This App').addClass('stop_link').on('click', (function(slot) {
        return function() {
          return Room.deactivateApp(slot);
        };
      })(slot));
      $choose = $('<a href="#">').text('Choose a ' + (slot === 0 ? 'App' : 'Bot')).addClass('toolbar_popup_link').on('click', (function(slot) {
        return function() {
          var appId, match;
          appId = prompt('Enter the App ID/URL or\nLeave empty to load from a file:');
          if (appId) {
            match = appId.match(/chaturbate\.com\/app\/[^\/]*\/([^\/]*)\/?/);
            if (match) {
              appId = match[1];
            }
            Room.loadAppFromCB(appId, slot);
          } else {
            Room.loadAppFromFile(slot);
          }
          return false;
        };
      })(slot));
      $restart = $('<a href="#options_slot' + slot + '">').text('Restart "' + app.name + '"').addClass('toolbar_popup_link').on('click', (function(slot) {
        return function() {
          return Room.activateApp(slot);
        };
      })(slot));
      if (app.cb instanceof CB) {
        $appName.addClass(slot === 0 ? 'top_row_center' : 'center').removeClass('center_empty').removeClass('top_row_center_empty').text(app.name);
        $appAction.append($deactivate);
      } else {
        if (app.script) {
          $appAction.append($choose);
          $appAction.append($('<span>').text(' or '));
          $appAction.append($restart);
        } else {
          $appAction.append($choose);
        }
        $appName.addClass(slot === 0 ? 'top_row_center_empty' : 'center_empty').removeClass('center').removeClass('top_row_center').text('None Selected');
      }
    }
  };

  Room.init = function() {
    var $chatList;
    $('body').html(function(index, html) {
      return html.replace(/{#ROOM_SUBJECT#}/g, Room.getSubject()).replace(/{#ROOM_SLUG#}/g, Room.getSlug());
    });
    $('#roomtitle').on('click', function() {
      $(this).hide();
      $('#roomtitleform').show().find('input[name=roomtitle]').val(Room.getSubject()).select();
      $('#tooltip-subject').show();
      return false;
    });
    $('#roomtitleform').find('input[value=Submit]').on('click', function() {
      Room.setSubject($('#roomtitleform').find('input[name=roomtitle]').val());
      $('#roomtitle').show();
      $('#roomtitleform').hide().find('input[name=roomtitle]').val(Room.getSubject());
      $('#tooltip-subject').hide();
      return false;
    });
    $('#roomtitleform').find('input[value=Cancel]').on('click', function() {
      $('#roomtitle').show();
      $('#roomtitleform').hide().find('input[name=roomtitle]').val(Room.getSubject());
      $('#tooltip-subject').hide();
      return false;
    });
    $('form.chat-form a.send_message_button').on('click', function() {
      $(this).closest('form').submit();
      return false;
    });
    $('form.chat-form').on('submit', function() {
      var input;
      input = $(this).find('#chat_input');
      Room.message(input.val());
      input.val('');
      return false;
    });
    $('.tip_shell .overlay_popup.tip_popup form').on('submit', function() {
      if (Room.getCurrentUser().has_tokens) {
        Room.tip($(this).find('#id_tip_amount').val(), $(this).find('#id_tip_msg_input').val() || $(this).find('#tip_options_select').val());
        $('.tip_shell div.overlay_popup.tip_popup').hide().find('#id_tip_msg_input').val('');
      } else {
        alert('You do not have enough tokens.');
      }
      return false;
    });
    $('.tip_shell .green_button_tip a.tip_button').on('click', function() {
      var j, len, option, ref, tipOptions;
      tipOptions = triggerHandler('tipOptions');
      if (tipOptions) {
        $('#id_tip_msg_input').prevAll('label').text(tipOptions.label);
        $('#id_tip_msg_input').replaceWith('<select name="tip_options" id="tip_options_select" style="width: 360px; height: 30px; "><option value="">-- Select One --</option>');
        ref = tipOptions.options;
        for (j = 0, len = ref.length; j < len; j++) {
          option = ref[j];
          $('#tip_options_select').append($('<option>').text(option.label));
        }
      } else {
        $('#tip_options_select').prevAll('label').text('Include an optional message:');
        $('#tip_options_select').replaceWith('<textarea style="width: 360px; height: 30px; margin-bottom: 3px;" id="id_tip_msg_input" name="message" maxlength="255"></textarea>');
      }
      $('.tip_shell div.overlay_popup.tip_popup').show().find('#id_tip_amount').select();
      return false;
    });
    $(document).on('mouseup', function(e) {
      var tip_popup;
      tip_popup = $('.tip_shell div.overlay_popup.tip_popup');
      if (!tip_popup.is(e.target) && tip_popup.has(e.target).length === 0) {
        tip_popup.hide();
      }
      return false;
    });
    $('#__users').on('change', function() {
      return Room.changeUser($(this).val());
    });
    $chatList = $('#defchat').find('div.section > div.chat-holder > div > div.chat-list');
    return $chatList.bind('DOMSubtreeModified', function() {
      if (($chatList.prop('scrollTop') + 30) > ($chatList.prop('scrollHeight') - $chatList.prop('offsetHeight'))) {
        return $chatList.prop('scrollTop', $chatList.prop('scrollHeight'));
      }
    });
  };

  return Room;

})();

$().ready(function() {
  Room.init();
  Room.loadApp('app/CBApp.js', 0);
  Room.loadApp('app/CBBot1.js', 1);
  Room.loadApp('app/CBBot2.js', 2);
  Room.loadApp('app/CBBot3.js', 3);
  return Room.updateUI();
});
