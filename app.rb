# encoding: utf-8

require 'sinatra'
require 'json'

require './helpers/passport.rb'

class NTraceServer < Sinatra::Base
  #set :environment, :production
  enable :sessions

  register Sinatra::Passport
  register Sinatra::RespondTo

  helpers do
    def paginate(query)
      @page        = (params[:page] || 1).to_i
      @per_page    = (params[:per_page] || 100).to_i

      @pages       = query.chunks_of(@per_page)
      @total_count = @pages.count
      @page_count  = @pages.length

      @pages[@page - 1]
    end

    def nl2br(s)
      s.to_s.gsub(/\r\n|\r|\n/, "<br />\n")
    end
    alias :h :nl2br
  end

  get '/ntrace' do
    "Hello world"
  end

  get '/ntrace/tasks' do
    authorize!

    @title = "任务列表"
    @record_properties = Task.properties.map {|p| p.name}
    @records = paginate Task.all

    respond_to do |format|
      format.html {
        haml :"tasks"
      }
      format.json {
        content_type 'application/json', :charset => 'utf-8'
        @tasks.to_json
      }
    end
  end

  get '/ntrace/task/:id' do
    authorize!

    @task = Task.get(params[:id])

    respond_to do |format|
      format.html {
        haml :"task_show"
      }
      format.json {
        @task.to_json
      }
    end
  end

  post '/ntrace/task/create' do
    authorize!

    @task = Task.create(
        :created_by => passport_username,
        :description => YAML.load(params[:description]).to_json
    )

    # flash
    redirect '/ntrace/tasks'
  end

  get '/ntrace/traces' do
    authorize!

    @title = "检测记录"
    @record_properties = Trace.properties.map {|p| p.name}
    @records = paginate Trace.all

    respond_to do |format|
      format.html {
        haml :"traces"
      }
      format.json {
        content_type 'application/json', :charset => 'utf-8'
        @traces.to_json
      }
    end
  end

  get '/ntrace/api' do
    "api"
  end

  get '/ntrace/api/task/:id' do
    @task = Task.get(params[:id])

    @task.description
  end

  post '/ntrace/api/task/:id/post' do
    @trace = Trace.create(
        :uid => params['_uid'],
        :ip => request.ip,
        :content => request.body.read,
        :task_id => params[:id]
    )

    @trace.id
  end
end
