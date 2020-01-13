require 'sinatra'
require 'sinatra/base'

class App < Sinatra::Base

  configure { set :server, :puma }

  configure :production, :development do
    enable :logging
  end

  get '/hello-world' do
    'hello world!'
  end

  not_found do
    'Page not found.'
  end
end
