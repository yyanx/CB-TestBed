# CB-TestBed
Develop and test your CB apps & bots in a page that simulate the Chaturbate environment.

- Check the [Apps & Bots Programming Documentation](https://chaturbate.com/apps/docs/index.html).
- Based on the idea from [CB-AppDevKit](https://github.com/brandonxavier/CB-AppDevKit).

### Download
Download the [latest release](https://github.com/yyanx/CB-TestBed/releases/latest) or [build](#build) it.

### Run
To be able to test your app on CB-TestBed, run the file `bin/run.sh`
or go to the project directory and run `python -m SimpleHTTPServer 8000` on terminal.
Now you can access [localhost:8000](http://localhost:8000) on your browser and test your app.

### Develop
Develop your apps & bots under the [app](app) directory.
Running multiple apps/bots at the same time are not realiable.

- `cb/CBApp.js` is the app file;
- `cb/CBBot#.js` are the bots files (# is number of the bot).

##### Settings
Currently the `defaultValue` of each setting will be loaded to the `cb.settings` object.

##### Debug
To enable or disable debug mode, type /debug into chat.

If you need to insert breakpoint in your code, user the [`debugger;` statement](http://www.w3schools.com/jsref/jsref_debugger.asp) and keep your Developer Tools console open. 

##### Reload
If you need to reload your app code, it is reloaded when you deactivate it.
No need to reload the page.

##### Emoticons
The default emoticons are available.
Put your custom emoticons under the [cb/emoticons](cb/emoticons) directory.

- `cool.jpg` -> `:cool` 
- `lmao.jpg` -> `:lmao` 
- ...

##### Users
If you want to add or remove users (onEnter/onLeave events) use your Developer Tools console to access the `Room` object:

- `Room.addUser(user)`, where `user` is an object:
    - user                : username of the user
    - gender              : "m" (male), "f" (female), "s" (trans), or "c" (couple)
    - in_fanclub          : is the user in the broadcasters fan club [default: false]
    - has_tokens          : does the user have at least 1 token [default: false]
    - is_mod              : is the user a moderator [default: false]
    - tipped_recently     : is the user a "dark blue" [default: false]
    - tipped_alot_recently: is the user a "purple" [default: false]
    - tipped_tons_recently: is the user a "dark purple" [default: false]
- `Room.removeUser(username)`, where `username` is a string with username of the user.

### Build
If want to build it yourself or if you need to modify the CB-TestBed code under the [src](src) directory,
run the file `bin/build.sh` or go to the project directory and run `cat src/*.coffee | coffee --bare --compile --no-header --stdio > script.js` on terminal.
Now run the CB-TestBed and test your app.

### Issues
If you are having problems, open a [new issue](https://github.com/yyanx/CB-TestBed/issues/new) or e-mail [yyan.nx@gmail.com](mailto:yyan.nx@gmail.com).

## License
Released under [The MIT License (MIT)](LICENSE.md).

###### Exception
All files under the [cb](cb) directory and the [index.html](index.html) file (some of them with modifications) are copyrighted to Chaturbate.com.