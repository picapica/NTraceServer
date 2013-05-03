require 'sinatra'

class NTraceServer < Sinatra::Base
  get '/ntrace' do
    "Hello world"
  end

  get '/ntrace/api' do
    "api"
  end
end
