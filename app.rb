require 'sinatra'
require 'json'

class NTraceServer < Sinatra::Base
  get '/ntrace' do
    "Hello world"
  end

  get '/ntrace/api' do
    "api"
  end

  get '/ntrace/api/task/1' do
    {
      :task_ping_1 => {:type => 'ping', :host => 'www.renren.com'},
      :task_ping_2 => {:type => 'ping', :host => 'www.twitter.com'},
      :task_fetch_1 => {:type => 'fetch', :file => 'http://s.xnimg.cn/100k.jpg'}
    }.to_json
  end

  post '/ntrace/api/task/1/post' do
    params['_uid']
  end
end
