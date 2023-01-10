require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require_relative './import_from_csv.rb'

get '/tests' do
  Import.new
  conn = PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres')
  tests = conn.exec("SELECT * FROM records ;")
  tests.map { |t| t }.to_json
end

get '/csv' do
  rows = CSV.read("./data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/index' do
  File.read('./app/index.html')
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)