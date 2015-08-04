# dspace

Code to interact with DSPACE core objects 

Thank you https://github.com/kardeiz/dscriptor to set me on the path to jruby with dspace 

## Installation

Prerequisite:  [JRuby] (http://jruby.org/getting-started).

Clone the repo: 

`git clone https://github.com/akinom/dscriptor.git`

Bundle:

`bundle`

You can then run your script like:

`bundle exec jruby myscript.rb   # not working` 

See the `examples` directory for examples.

## Usage

Create a new script `*.rb` file.

Require the gem and any other dependencies you might have:

```
require 'dspace'
```

Connect to your dspace database and configurations 

```
DSpace.load                                  # load from ENV[$DSPACE_HOME] if set otherwise loads from /dspace
DSpace.load("/home/you/installs/dspace")     # load from /home/you/installs/dspace
```

Use the included classes DSO, DCommunity, DCollection and so forth; see in lib/dspace. 
This is work in progress 

Remember to call the commit methods if you want changes to be pushed to the database 

```
DSpace.commit 
```

If you want to make changes you can 'login' 

```
DSpace.login ('youraccount') 
```

## Interactive Usage 

The included console script starts an interactive console, where you can 

```
require 'dspace'
DSpace.load          # connect to your DSPACE 
DSO.help             # prints help on all static methods of all classes derived from the DSO class  
```

Use Tab completion to see available methods 


## Note 

The code expects a fromString Methaod in the Java DSpaceObject class and corresponding changes to toString, see 
 
[dspace-api/src/main/java/org/dspace/content/DSpaceObject.java] (https://github.com/DSpace/DSpace/pull/704/files#diff-00207c956383ac205c3c205e97982aa0)

[dspace-api/src/main/java/org/dspace/eperson/EPerson.java] (https://github.com/DSpace/DSpace/pull/704/files#diff-dcd646e81771d153a0ae7441cd2bab8a)

[dspace-api/src/main/java/org/dspace/eperson/Group.java](https://github.com/DSpace/DSpace/pull/704/files#diff-ec4ae1abb115d7be8774c6885c64f51f)
