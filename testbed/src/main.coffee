$().ready ->
  Room.init()
  Room.loadApp('app/CBApp.js', 0)
  Room.loadApp('app/CBBot1.js', 1)
  Room.loadApp('app/CBBot2.js', 2)
  Room.loadApp('app/CBBot3.js', 3)
  Room.updateUI()
