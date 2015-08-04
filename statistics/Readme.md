
statistics/community.rb  compiles statistics information on number of accesses recorded in solr - stats; 

it produces tab separated tables 
> 1. showing the total number of collection, item, bitstream views/downloads per community. 
> 2. and/or a listing of the top performing bitstreams in the given communities
    
numbers can be filtered by time slots. 

you can give a list of ip that should be excluded 

you can request to exclude entries marked with isBot=1 

see the included statistics/community.yml for an example parameter file

you can print the usage with:   

```
jruby -I lib statistics/community.rb  --help 
```

