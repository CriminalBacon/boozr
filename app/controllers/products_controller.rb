require 'tesco'
require 'sainsburys'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.order(:name)
    @search = params['search']
    if @search.present?
      @name = @search['name']
      @products = Product.where('name LIKE ?', "%#{@name}%").order(:name)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    # @product.destroy
    # respond_to do |format|
    #   format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
    #   format.json { head :no_content }
      # end
    Product.delete_all

    tesco = TescoScraper.new
    sainsburys = SainsburyScraper.new

    s_p_and_p = sainsburys.get_products_and_prices
    s_p_and_p.each do |name, price|
      Product.create(store: 'S', name: name, price: price)
    end

    t_p_and_p = tesco.get_products_and_prices
    t_p_and_p.each do |name, price|
      Product.create(store: 'T', name: name, price: price)
    end
    
    redirect_to root_path

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      # params.fetch(:product, {})
      params.require(:product).permit(:name, :search)
    end
end
