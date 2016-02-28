# CB-TestBed
Develop and test your CB apps & bots in a page that simulate the Chaturbate environment.

- Check the [Apps & Bots Programming Documentation](https://chaturbate.com/apps/docs/index.html).
- Based on the idea from [CB-AppDevKit](https://github.com/brandonxavier/CB-AppDevKit).

### Live version
Access the [live version](https://yyanx.github.io/CB-TestBed/) and start testing your app without the need to setup a server.

### Develop
**Running multiple apps/bots at the same time is not realiable.**  
When running locally, develop your apps & bots under the [app](app) directory:

- `cb/CBApp.js` is the app file;
- `cb/CBBot#.js` are the bots files (# is number of the bot).

##### Debug
To enable or disable debug mode, type /debug into chat.  
If you need to insert breakpoint in your code, user the [`debugger;` statement](http://www.w3schools.com/jsref/jsref_debugger.asp)
and keep your Developer Tools console open. 

##### Emoticons
Put your custom emoticons under the [cb/emoticons](cb/emoticons) directory.  
The standard emoticons are available:

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

##### Reload
When running locally, if you need to reload your app code, it is reloaded when you deactivate it. No need to reload the page.

### Download
If you want to run locally, download the [latest release](https://github.com/yyanx/CB-TestBed/releases/latest).

### Run locally
Run the file `bin/run.sh` or go to the project directory and run `python -m SimpleHTTPServer 8000` on terminal.
Now you can access [localhost:8000](http://localhost:8000) on your browser and test your app.  
Or setup your server and put the CB-TestBed files on it.

### Build
Run the file `bin/build.sh` or go to the project directory and run `cat src/*.coffee | coffee --bare --compile --no-header --stdio > script.js` on terminal.  
Now run the CB-TestBed and test your app.

### Issues
If you are having problems, open a [new issue](https://github.com/yyanx/CB-TestBed/issues/new) or e-mail [yyan.nx@gmail.com](mailto:yyan.nx@gmail.com).

## License
Released under [The MIT License (MIT)](LICENSE.md).

###### Exception
All files under the [cb](cb) directory and the [index.html](index.html) file (some of them with modifications) are copyrighted to Chaturbate.com.