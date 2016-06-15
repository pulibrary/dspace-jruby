# jrdspace

jrdsapce is implemented in JRuby. 

It provides a simple mechanism to connect to a [DSpace](https://github.com/DSpace/DSpace) installation and to access and manipulate the Java Objects managed by classes from the dspace-api package. 

jrdspace contains an interactive console and therefore enables quick experimentation. 

The companion project [cli-dspace](https://github.com/akinom/dspace-cli)  contains utilities that make use of jrdspace.

Documentation is also available at [rubydoc.info](http://www.rubydoc.info/github/akinom/dspace-jruby)

I would like to hear from you if you download and use jrdsapce. Please do send me your feedback and PRs. 

## Installation

### Prerequisite
 * JRuby  [Get Started](http://jruby.org/getting-started)
 * Package Manager  [Bundler](http://bundler.io/)
 * optional - but useful [RVM](https://rvm.io/)

### Installation 

Add the gem to your projects Gemfile: 

```
gem 'jrdspace'      # pull from rubygems 

gem 'jrdspace', :git => 'https://github.com/akinom/dspace-jruby', :branch => 'master`

```

Install the gem:

```
bundle install
```

Please note that I am still updating this gem frequently as I discover bugs.
So please update frequently with 

```
bundle update
```

##  Usage 

To use in scripts simply include the following 

```
require 'dspace' 
DSpace.load(dspace_install_dir) 
```

## Interactive Usage 

The included idspace command starts an interactive console.

```
bundle exec idspace 
> DSpace.load          # load DSpace jars and configurations 
> DSpace.help          # lists all static methods of classes in jrdspace 
```

Use Tab completion to see available methods 

# Get Started 

Connect to your dspace database and configurations 

```
DSpace.load                                  # load DSpace jars and configurations from ENV[DSPACE_HOME] 
                                             # or from /dspcae if DSPACE_HOME is undefined
DSpace.load("/home/you/installs/dspace")     # load from /home/you/installs/dspace
```

The load method sets the environment up by reading configurations from the dspace.cfg file and by requiring all jar files from the ${dspace.dir}/lib directory.  After a succesfull load you can start using Java classes by importing them, for example: 

```
 java_import org.dspace.content.Item;
``` 
The included classes DSpace, DCommunity, DCollection, ... from [lib/dspace](lib/dspace) 
provide convenience methods, such as retrieving all Communities  finding individual objects: 

```
DCommunity.all
DSpace.fromString ('some/handle')      
DSpace.fromString ('ITEM.124')      
DCollection.find(10)     
DEPerson.find ('email@there.edu')  
DGroup.find('Anonymous') 
DGroup.find(1) 
DMetadataField.find('dc.contributor')
```

If you want to make changes you can 'login' 

```
DSpace.login               # login with ENV['USER']
DSpace.login ('netid')     # login with given netid
```

Remember to call the commit method if you want to save changes

```
DSpace.commit 
```

The following prints a rudimentary community report:

```
DCommunity.all.each { |c| puts [c.getCollections.length, c.getHandle, c.getName].join("\t") }
```

Java objects can be converted to corresponding jrdspace objects, so that the additional functionality implemented by jrdspace classes becomes available. 
For example all jrdspace objects derived from DSpaceObjects implement the parents, policies, and  getMetaDataValues method:

```
dso = DSpace.fromString('xxxxx/zzz') 
DSpace.create(dso).parents
DSpace.create(dso).policies
DSpace.create(dso).getMetaDataValues
```


# Thanks 
Thank you https://github.com/kardeiz/dscriptor to set me on the path to jruby with dspace 
