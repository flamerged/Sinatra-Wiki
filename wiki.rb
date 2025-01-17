require "sinatra"
require "uri"

def page_content(title)
  File.read("pages/#{title}.txt")
rescue Errno::ENOENT
  nil
end

def save_content(title, content)
  File.open("pages/#{title}.txt", "w") do |file|
    file.print(content)
  end
end

def delete_content(title)
  File.delete("pages/#{title}.txt")
end

get "/" do
  erb :welcome
end

get "/new" do
  erb :new
end

get "/:title" do
  # params is a hash type and we therefore access the title param by using [:title]
  @title = params[:title]
  @content = page_content(@title)
  if @content
    erb :show
  else
    erb :noexist
  end
end

get "/:title/edit" do
  @title = params[:title]
  @content = page_content(@title)
  erb :edit
end

post "/create" do
  @title = params[:title]
  @content = params[:content]
  save_content(@title, @content)
  redirect URI.escape("/#{@title}")
end

put "/:title" do
  save_content(params[:title], params[:content])
  redirect URI.escape("/#{params[:title]}")
end

delete "/:title" do
  delete_content(params[:title])
  redirect "/"
end
