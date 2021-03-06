require "pry"
require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/contrib/all"
require "httparty"
require "json"
require "pg"

before do

  @db = PG.connect(dbname: 'movies_app', host: 'localhost')

end

after do

  @db.close

end


get '/' do

  erb :movie
  
end

get '/home' do

  erb :movie

end

get '/movie' do
  @title = params[:title]
  if @title && @title > ""
    @url_title = @title.tr(" ", "+")
    url = "http://www.omdbapi.com/?t=#{@url_title}"
    html = HTTParty.get(url)
    @hash = JSON(html)

    sql= "insert into movies (title, year, rated, released, runtime, genre, director, writers, actors, plot, poster) values ('#{@hash['Title']}', '#{@hash['Year']}', '#{@hash['Rated']}', '#{@hash['Released']}', '#{@hash['Runtime']}', '#{@hash['Genre']}', '#{@hash['Director']}', '#{@hash['Writer']}', '#{@hash['Actors']}', #{sql_string(@hash['Plot'])}, '#{@hash['Poster']}')"

    @db.exec(sql)

  end

  erb :movie

end

get '/movies' do

  sql = "select * from movies"
  
  @movies = @db.exec(sql)

  erb :movies

end

def sql_string(value)
  "'#{value.gsub("'", "''")}'"
end





