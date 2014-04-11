require 'sinatra/base'

class Persister
  @@all = {}
  attr_reader :id
  def save
    if id.nil?
      new_id = @@all.count
      @@all[new_id.to_s] = self
      @id = new_id
    else
      @id
    end
  end

  def <=> ingredient
    id <=> ingredient.id
  end

  def self.find id
    @@all[id]
  end

  def self.all
    @@all.values
  end
end

class Ingredient < Persister
  attr_accessor :amount
  attr_accessor :name
end

class Recipe < Persister
  attr_accessor :name
  attr_accessor :instructions
  attr_accessor :ingredients

  def initialize(fields)
    @ingredients = []
    self.name = fields['name']
    self.instructions = fields['instructions']
  end

  def add_ingredient ingredient
    @ingredients << ingredient
  end

  def remove_ingredient ingredient
    @ingredients.reject! do |i|
      i == ingredient
    end
  end
end

class App < Sinatra::Application
  get '/recipes' do
    erb :index, locals: { recipes: Recipe.all }
  end
  post '/recipes' do
    recipe = Recipe.new(params[:recipe]) #implement
    recipe.save
    redirect '/recipes'
  end
  get '/recipes/:id' do
    erb :show, locals: { recipe: Recipe.find(params[:id]) }
  end
  get "/recipes/:id/edit" do
    erb :edit, locals: { recipe: Recipe.find(:id) }
  end
  #put recipe/:id
  # - Recipe.update(params[:recipe]) #implement
  # - redirect get_recipe
  #post recipe/:id/ingredients
  # - ingredient = Ingredient.new(params[:ingredient])
  # - Recipe.find(:id).add_ingredient(ingredient)
  # - redirect get_recipe
  #delete recipe/:recipe_id/ingredients/:id
  # - ingredient = Ingredient.find(params[:id])
  # - Recipe.find(params[:recipe_id]).remove_ingredient(ingredient)
  # - redirect get_recipe
end