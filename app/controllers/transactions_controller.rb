class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = Transaction.where(user: current_user)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  def new
    @transaction = Transaction.new
    @transaction.user = current_user
    @categories = Category.all
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    if @transaction.save
      redirect_to transaction_path(@transaction)
    else
      render :new
    end
  end

  def transaction_params
    params.require(:transaction).permit(:name, :amount, :description, :category_id, :transaction_date)
  end

end
