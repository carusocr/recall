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
duration = {}

DB = Sequel.connect('sqlite://recall.db')

unless DB.table_exists?(:notes)
	DB.create_table :notes do
		primary_key :id
		String :content, null: false
		String :comment
		String :status, default: 'new'
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

#testing better format
class Note < Sequel::Model
end
		
def task_create(content, repeater)
	Note.create(content: params[content],
							repeater: params[repeater],
							created_at: $curday)
end

def edit(id,field)
  @note = Note.where(id: params[:id]).first
  @title = "Edit note ##{params[id]}"
  erb :edit, :locals => {:field => field}
end

def save(id, field)
  n = Note.where(id: params[:id]).first
  if field == 'comment'
    n.comment = params[:comment]
  else
    n.content = params[field]
  end
  n.updated_at = Time.now
  n.save
  redirect '/'
end

def check_repeaters()
  if Date.today.day == 10
    Note.find_or_create(:content=>"Rotate Mattress",:created_at=>Date.today)
  end
  repeaters = Note.where(repeater: true).each do |rep|
    if rep.created_at.cwday == Date.today.cwday and rep.complete == true and rep.created_at != Date.today
      # make new note, same content
      rep.repeater = false
      rep.save
      Note.create(repeater: true, complete: false, status: 'new', created_at: Date.today, content: rep.content)
    end
  end
end

get '/' do
  check_repeaters()
  notes = DB[:notes]
	@notes = notes.all
	@title = ' - CRC - '
	erb :home, locals: {curday: $curday}
end

get '/:id/comment' do
  edit(:id, 'comment')
end

put '/:id/content' do
  save(:id, 'content')
end

put '/:id/comment' do
  save(:id, 'comment')
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

get '/:id' do
  edit(:id, 'content')
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


get '/:id/complete' do
  n = Note.where(id: params[:id]).first
  puts n[:status].inspect
  if n[:status] == 'new' || n[:status] == 'slack' || n[:active] == true
    n[:status] = 'done'
    n[:complete] = true
    n[:active] = false
  elsif n[:complete] == true
    n[:status] = 'new'
    n[:complete] = false
    duration["#{n}"] = 0
  end
  n[:updated_at] = Time.now
  n[:completed_at] = $curday
  n.save
  redirect '/'
end

get '/:id/delete' do
	Note.where(id: params[:id]).delete
  redirect '/'
end

get '/:id/activate' do
  n = Note.where(id: params[:id]).first
  if (n.active == true || n.status == 'doing')
    n.status = 'new'
    n.active = false
  elsif (n.status == 'new' || n.status == 'overdue') && $curday == Date.today
    n.status = 'doing'
    n.active = true
  end
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/slack' do
  n = Note.where(id: params[:id]).first
  n.status = :slack
  n.updated_at = Time.now
  n.save
  edit(:id, 'comment')
end

