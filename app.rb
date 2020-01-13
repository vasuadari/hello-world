require 'sinatra'
require 'sinatra/base'

class App < Sinatra::Base

  configure { set :server, :puma }

  get '/hello-world' do
    'hello world!'
  end
end
