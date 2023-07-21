#!/usr/bin/env ruby

=begin
Ok, I have a version that does Sinatra and datamapper. Can I keep using Sinatra? I 
like how lightweight it was
=end

require 'sequel'
require 'haml'
require 'active_support/all'
require 'sinatra'

$curday = Date.today

DB = Sequel.connect('sqlite://recall.db')

unless DB.table_exists?(:notes)
	DB.create_table :notes do
		primary_key :id
		String :content, null: false
		String :comment
		String :status
		Date :created_at
		Date :task_date
		DateTime :updated_at
		DateTime :completed_at
		Integer :duration, default: 0
		TrueClass :priority, default: false
		TrueClass :complete, default: false
		TrueClass :active, default: false
		TrueClass :repeater, default: false
	end
end
				
		
get '/' do
  #notes = Note.all(:created_at => $curday) | Note.all(:created_at.lt => Date.today, :status => :new) | Note.all(:completed_at => $curday) | Note.all(:status => :doing)

  notes = DB[:notes]
	return notes.all.to_json

  #@title = ' - CRC - '

  #haml :home, :locals => {:curday => $curday}

  'Wake up!'
end

Sinatra::Application.run!
