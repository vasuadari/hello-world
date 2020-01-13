require 'sinatra'
require 'sinatra/base'

class App < Sinatra::Base
  get '/hello-world' do
    'hello world!'
  end
end
