#!/usr/bin/env jruby -I lib

require 'optparse'

require 'dscriptor'
include Dscriptor::Mixins
module DSO
  module Collections
  class Copy
    def initialize(options)
      # $stdout.puts options.inspect

      coll = options[:template_coll];
      raise "must give template collection to copy" if coll.nil?

      netid = options[:netid];
      raise "must give netid of authorized user" if netid.nil?

      @projectgrantnumber = options[:grant]

      Dscriptor.configure.prepare

      @user =  EPerson.findByNetid(dspace_context, netid)
      raise "#{netid} not a valid netid" if (@user.nil?)
      dspace_context.setCurrentUser(@user)

      if (coll.index('/') > 0) then
        @template_coll = HandleManager.resolveToObject(dspace_context, coll)
      else
        @template_coll = Collection.find(context, coll.to_i);
      end
      if (! @template_coll)
        raise "must give a valid template_coll - id or handle";
      end
      parent = options[:parent_handle];
      if (parent) then
        @parent = HandleManager.resolveToObject(dspace_context, parent)
      else
        @parent = @template_coll.getParentObject()
      end
      if (! @parent)
        raise "ehh ?? - how can #{@template_coll} not have a parent";
      end
      if (@parent.getType() != 4 and @parent.getType() != 3 ) then
        raise "parent must be a collection or community"
      end
      @name = options[:name] || @template_coll.getName();
      @name = @name.strip();
    end

    def doit()
      puts "copying\t\t#{@template_coll} #{@template_coll.getName()}"
      puts "copying into\t#{@parent} #{@parent.getName()}"
      puts "naming it \t'#{@name}'"
      puts "template item with pu.projectgrantnumber=#{@projectgrantnumber}" if (@projectgrantnumber)

      new_col = Collection.create(dspace_context, nil)
      new_col.setMetadata("name", @name)
      @parent.addCollection(new_col)
      puts "Created #{new_col.getHandle()}"

      group = @template_coll.getSubmitters();
      if (group) then
        new_group = new_col.createSubmitters
        copy_group(group, new_group)
      end

      [1,2,3].each do |i|
        group =   @template_coll.getWorkflowGroup(i);
        if (group) then
          new_group = new_col.createWorkflowGroup(i)
          copy_group(group, new_group)
        end
      end

      if (@template_coll.hasCustomLicense()) then
        puts "copy license"
        new_col.setLicense(@template_coll.getLicenseCollection())
      end

      if (@projectgrantnumber) then
        puts "create template item with pu.projectgrantnumber=#{@projectgrantnumber}"
        new_col.createTemplateItem()
        titem = new_col.getTemplateItem()
        titem.addMetadata("pu", "projectgrantnumber", nil, nil, @projectgrantnumber)
        titem.update
      end

      puts "default authorization left in place";

      new_col.update()
      dspace_context.commit()
      puts "Commited #{new_col.getHandle()}"

    end

    def copy_group(from, to)
      puts "create group #{to.getName()} based on #{from.getName()}"
      sub_groups = from.getMemberGroups()
      sub_groups.each do |g|
        puts "#{to.getName()}: add #{g.getName()}"
        to.addMember(g);
      end
      from.getMembers().each do |g|
        puts "#{to.getName()}: add #{g.getName()}"
        to.addMember(g);
      end
      to.update
    end

    def self.run()
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: #{__FILE__} [options] \n" +
        "copy template collection to parent object"

        opts.on("-c", "--collection id_or_handle", "collection template") do |v|
          options[:template_coll] = v
        end

        opts.on("-e", "--eperson netid", "netid of authorized user") do |v|
          options[:netid] = v
        end

        opts.on("-G", "--grant projectgrantnumber", "pu.projectgrantnumber for item template") do |v|
          options[:grant] = v
        end

        opts.on("-p", "--parent handle", "use given object as parent for new collection") do |v|
          options[:parent_handle] = v
        end

        opts.on("-n", "--name name", "name of new collection") do |v|
          options[:name] = v
        end
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end

      begin
        parser.parse!
        copier = self.new(options).doit();
      rescue Exception => e
        puts e.message;
        puts parser.help();
      end
    end
  end
  end
end

DSO::Collections::Copy.run();