class CustomersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
    include ApplicationHelper
    
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    # GET /customers
    # GET /customers.json
    # def index
    #   @customers = Customer.all
    # end

    def index
      if current_user.role.nil?
        flash.notice = "You are not authorized for that operation."
        redirect_to home_index_path
      elsif current_user.role.include?("volunteer")
        @customers = current_user.customers
      else current_user.role.include?("administrator") || current_user.role.include?("intern")
        @customers = Customer.all
      end
    end
  
    # GET /customers/1
    # GET /customers/1.json
    def show
    end
  
    # GET /customers/new
    def new
      @customer = Customer.new
    end
  
    # GET /customers/1/edit
    def edit
    end
  
    # POST /customers
    # POST /customers.json
    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        flash.notice = "The customer record was created successfully."
        redirect_to @customer
      else
        flash.now.alert = @customer.errors.full_messages.to_sentence
        render :new  
      end    
    end
  
    # PATCH/PUT /customers/1
    # PATCH/PUT /customers/1.json
    def update
      if @customer.update(customer_params)
        flash.notice = "The customer record was updated successfully."
        redirect_to @customer
      else
        flash.now.alert = @customer.errors.full_messages.to_sentence
        render :edit
      end
    end
  
    # DELETE /customers/1
    # DELETE /customers/1.json
    def destroy
      @customer.destroy
      respond_to do |format|
        format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_customer 
        @customer = Customer.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def customer_params
        params.require(:customer).permit(:first_name, :last_name, :phone, :email, :street, :city, :state, :zip)
      end

      def catch_not_found(e)
        Rails.logger.debug("We had a not found exception.")
        flash.alert = e.to_s
        redirect_to customers_path
      end

     
end  

  
