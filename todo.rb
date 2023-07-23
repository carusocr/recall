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
	@notes = notes.all
	@title = ' - CRC - '
	erb :home, locals: {curday: $curday}

end

get '/present' do
  $curday = Date.today
  redirect '/'
end

get '/nextday' do
  $curday = $curday + 1.day
  redirect '/'
end

get '/prevday' do
  $curday = $curday - 1.day
  redirect '/'
end

post '/datejump' do
  if params[:newdate] == ''
  else
    $curday = Date.strptime("#{params[:newdate]}", '%m/%d/%Y') #fix date format
    redirect '/'
  end
end

post '/' do
  task_create(:content, :repeater)
  redirect '/'
end

def task_create(content, repeater)
  puts DB[:notes].all.inspect
  DB[:notes].insert(:content=> params[content], :repeater=> params[repeater], :created_at=> $curday)
end
