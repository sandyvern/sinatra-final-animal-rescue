require 'rack-flash'

class AnimalsController < ApplicationController
  use Rack::Flash

  ### ANIMALS INDEX ACTION ###

  get '/animals' do
    erb :'animals/index'
  end

  ### CREATE ACTIONS ###

  get '/animals/new' do
    if !logged_in?
      flash[:error] = "You must log in to add an animal."
      redirect '/login'
    else
      erb :'animals/new'
    end
  end

  post '/animals' do
    if params[:name] == "" ||
       params[:species] == "" ||
       params[:breed] == "" ||
       params[:age] == ""
      redirect '/animals/new'
    else
      animal = Animal.create(params["animal"])
      flash[:success] = "You have successfully added #{animal.name}"
      redirect "/animals/#{animal.id}"
    end
  end

  ## SHOW/READ ACTION ##

  get '/animals/:id' do
    @animal = Animal.find(params[:id])
    erb :'animals/show'
  end

  ## EDIT ACTIONS ##

  get '/animals/:id/edit' do
    if logged_in?
      @animal = Animal.find(params[:id])
      if @animal.shelter.user_id == current_user.id
        erb :'animals/edit'
      else
        redirect '/animals'
      end
    else
      redirect '/login'
    end
  end

  patch '/animals/:id' do
    @animal = Animal.find(params[:id])
    @animal.update(name: params[:name], species: params[:species], breed: params[:breed], age: params[:age], shelter_id: params["animal"][:shelter_id])
    flash[:success] = "You have successfully edited #{@animal.name}"
    redirect "/animals/#{@animal.id}"
  end



end