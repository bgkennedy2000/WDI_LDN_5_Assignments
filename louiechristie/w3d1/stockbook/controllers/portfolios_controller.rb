get '/portfolios' do
  @portfolios = Portfolio.all
  @stocks = Stock.all
  erb :'portfolios/index'
end

get '/portfolios/:id' do
  @portfolio = Portfolio.find(params[:id])
  @stocks = @portfolio.stocks
  erb :'portfolios/show'
end

get '/portfolio/new' do
  @categories = Category.all
  @portfolio = Portfolio.new
  erb :'portfolios/new'
end

post '/portfolios' do
  @portfolio = Portfolio.new(params[:portfolio])
  @portfolio.save

  redirect to('/portfolios')
end

get '/portfolios/edit/:id' do
  @portfolio = Portfolio.find(params[:id])
  @categories = Category.all
  erb :'portfolios/edit'
end

post '/portfolios/:id' do
  @portfolio = Portfolio.find(params[:id])
  @portfolio.update_attributes(params[:portfolio])
  redirect to("/portfolios")
end

get '/portfolios/:id/delete' do
  Portfolio.find(params[:id]).destroy
  redirect to('/portfolios')
end