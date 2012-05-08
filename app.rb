require 'sinatra'
require 'persist'

get '/' do
  Persist.pull
  
  unless Persist.store[:people].kind_of? Array
		Persist.store[:people] = []
		Persist.push
	end
  
  erb :index
end

post '/' do
  name = params[:name]
  redirect '/' if name.empty?
  name.capitalize!
  Persist.pull

  if Persist.store[:people].include? name
    redirect back
  else
    Persist.store[:people] << name
    Persist.store[:people].sort!
    Persist.push
  end

  redirect '/'
end

post '/remove' do
  name = params[:name]
  redirect '/' if name.empty?
  name.capitalize!
  Persist.pull

  if Persist.store[:people].include? name
    Persist.store[:people].delete(name)
    Persist.push
  end

  redirect '/'
end

__END__

@@layout
<!doctype html>
<html lang='en'>
<head>
  <title>Maglev-Sinatra</title>
  <meta charset='utf-8' />
</head>
<body>
  <section>
    <%= yield %>
  </section>
</body>
</html>

@@index
<section>
  <h1>People</h1>
  <ul>
		<% Persist.store[:people].each do |person| %>
    	<li><%= "#{person}" %></li>
  	<% end %>
  </ul>
</section>
<section>
  <form action='/' method='post'>
    <input type='text' name ='name' placeholder='First name' />  
    <button type='submit'>Add</button>
  </form>
</section>
<section>
  <form action='/remove' method='post'>
    <input type='text' name ='name' placeholder='First name' />  
    <button type='submit'>Remove</button>
  </form>
</section>