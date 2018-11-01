# linuxRstuff
a collection of random scripts and notes that help R-Users working in Linux. I have NO idea what the hell I'm doing... only gain insight by headbutting problems till they break... so pull-requests, comments, issues are welcome.

## Scripts:
For all of these scripts, either clone the folder into your server (probably easiest), or `touch` a new file, then edit that file and drop the code in.

**but no matter what you do** Remember to make the file executable by using `chmod 777 filename`. You can then jump into the folder containing these files and run it like this: `./file.sh`

 - **Rinstaller.sh** - create a file like this in your server and use it to install packages. That way, the packages will be available for all users.
  - **chek.sh** - a file that you can use to see if an R script is running... if it's running, then do nothing... if it's NOT running, then it assigns the working directory, and restarts the file.
  - **forUpdates.sh** - Use this file when the server requires updates... it first updates, then upgrades, tehn updates the distro(? - I think), then it autoremoves stuff that's no longer required, then autocleans. I'm debating throwing a `reboot` in there... prolly shouldn't... but it would be convenient. Anyway, this is how you grab all that stuff in the correct order. I copypasted this from somewhere but can't find it anymore... if anyone knows where I stole it from pls raise an issue and I'll add the source.

## Tips:

Find files anywhere (starting from current location `sudo find . -name file.extension`

**Set up R cron jobs like this:**
`40 * * * * Rscript "path/file.R" >> /home/YourLinuxUsername/NewLogger.log 2>&1`

This way you'll have a log file that outputs the contents of each run.

## User stuff

`cut -d: -f1 /etc/passwd` display all users

`useradd x` add a user called x. Might have to sudo

`passwd x` change the password for x

`gpasswd -a x sudo` Add user to sudo group

`sudo chown -R x:y /FOLDER` Transfer ownership a file/folder to user `x` and/or group `y` CAREFUL!

`sudo groupadd y` Add a group

`sudo usermod -aG y x` add user `x` to group `y`



## Port stuff
If you have [ufw](https://help.ubuntu.com/lts/serverguide/firewall.html) installed, to open or close a port:

`sudo ufw allow XXX` (or `deny`)

to list open ports

`netstat -tulnp | grep "LISTEN"` 

## Locale stuff:

`sudo locale-gen en_US` Set a locale. Sometimes for some reason this needs to be manually edited in a few other places... for example: 

`sudo nano /etc/default/locale` and `sudo nano /etc/environment`, and then finally, you have the big one `sudo dpkg-reconfigure locales`.

After you're done, you need to `sudo reboot`. Then you can check your new stuff using `locale` or `env`.


## START STOP RESTART COMMANDS

```
sudo systemctl status shiny-server
sudo systemctl stop shiny-server
sudo systemctl start shiny-server
sudo systemctl restart shiny-server
sudo systemctl status shiny-server
```

```
sudo rstudio-server status
sudo rstudio-server start
sudo rstudio-server stop
sudo rstudio-server restart
```

## ShinyServer stuff

`sudo nano /etc/shiny-server/shiny-server.conf` Shortcut to edit shiny's config folder

`tail -n 20 /var/log/shiny-server.log` see last 20 lines of the shiny-server log. If you want to see the logs for the individual apps, these are in `cd /var/log/shiny-server/` and then dig around.


## Write access:
`sudo chmod -R 750 FileOrFolder`

where the numbers mean:4 stands for "read",2 stands for "write",1 stands for "execute", and0 stands for "no permission.". Add them up to come up w/ the number. The three numbers stand for "user", "group", and "other". the `-R` means Recursive (as in the case of a folder). Read more [here](https://www.computerhope.com/unix/uchmod.htm): 

## Database stuff
To see more about installing ODBC sources in a db, check out [my blog article](http://amitkohli.com/how-to-move-odbc-dsn-information-from-one-computer-to-another/).

`odbcinst -s -q` Checks whether an ODBC Source has been installed or not
`odbcinst -d -q` Shows the actual ODBC sources

`isql -v mydsn myusername mypassword` Establishes a connection to the db (as a minimum test to see if all the credentials work).

## Setting up links
In order to sync all files from one folder to the other, you need to set up a symlink (use case is for example to get data to copy into a folder that the dropbox daemon is watching.

`ln -s SOURCE_FOLDER FINAL_FOLDER`

## Git stuff
There's so much to say... let's keep it simple:

`sudo git stash` - Just bulldoze whatever local changes... a bit safer than the following option. Do this when you have a script running 
on the server that may have modified some tracked output files.... and you don't really want to deal with it.

`sudo git reset --hard` - Goes back to the last commit, this demolishes all local changes with no record. Careful!

When you have a merge conflict:

`git status` to see what's conflicting, and then:
`git checkout --ours FILE.html` to accept the new change... or `theirs` to accept the server version. 

## Dropbox
Following the instructions [here](https://www.dropbox.com/en_GB/install-linux) are pretty painless... except if you want to perform a selective sync. In that case, make sure you install the `dropbox.py` they recommend, and keep in mind these two commands:

`~/utils/dropbox.py exclude add *`      (exclude EVERYTHING from sync)

`~/utils/dropbox.py exclude remove DIR` (remove DIR from exclusion list)

## Web srvr stuff
 If you have lighttpd as a web server... 

`/etc/init.d/lighttpd stop`
 
 `/etc/init.d/lighttpd start`
 
 ... or nginx
 
 `nginx -V` To see general configuarion options, like who installed, where etc. For me:
 
   `sudo nano /etc/nginx/sites-enabled/default` to edit configuration
   
   `/usr/share/nginx ` thinks it's the site, but it's actually here: `/var/www/html/index.nginx-debian.html`
   
   `/var/log/nginx/access.log` log file
  
 To enable nginx basic password protection (not sure if all of this is necessary, but it does appear to be sufficient):
 
 ```
  root /usr/share/nginx/html;
  index index.html index.htm index.nginx-debian.html;
  server_name localhost;
  auth_basic "Restricted Content";
  auth_basic_user_file /etc/nginx/.htpasswd;
```

`sudo service nginx restart` restart

## System Resources stuff

To see how much memory and swap space you have available you can type `top` but it's much better if you install and then run `htop`.

To see how much hard drive room you have you can type:

`df -h`

Or to have more details, 

`sudo ncdu /`

To for example single out Specific items we can also combine with `awk` command... so for example, to get size, % used and available of `sda2`, we can type:

`df -hl | awk '/sda2/{print $2,$5,$4}'`

The `sudo` and the `/` are important otherwise it'll only give you the space allocation of the current folder. I found that some packages really abuse the `/tmp` file, but it's not necessary to use some hardcore tmp cleaner, it's enough to reboot the server.
