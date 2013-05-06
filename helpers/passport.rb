# encoding: utf-8

require 'sinatra/base'
require 'uri'
require 'net/https'
require 'net/https'

PASSPORT_HOST = ENV['PASSPORT_HOST'] || 'passport.no.opi-corp.com'

module Sinatra
  module Passport

    module Helpers

      def authorized?
        session && session['username']
      end

      def authorize!
        unless authorized?
          session[:original_url] = request.url
          redirect '/login'
        end
      end

      def passport_username
        session['username'] if session and username = session['username']
      end
    end

    def self.registered(app)
      app.helpers Passport::Helpers

      app.get '/login' do
        if session and username = session['username']
          redirect '/#login'

        elsif params and params[:ticket]
          url = URI "https://#{PASSPORT_HOST}/verify.php?t=#{params[:ticket]}"

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true if url.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE

          resp = http.request_get(url.request_uri, {'Referer' => request.url})
          username = resp.body
          session[:username] = username
          redirect session[:original_url] || '/#login_t'

        else
          redirect "https://#{PASSPORT_HOST}/login.php?forward=#{request.url}"

        end

      end
      app.get '/logout' do
        session[:username] = nil

        redirect '/'
      end
      app.get '/me' do
        redirect '/'
      end

    end
  end

  register Passport
end
