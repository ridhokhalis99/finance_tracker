class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result(distinct: true).where(user_id: current_user.id).order(transaction_date: :desc)
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
      flash[:error] = @transaction.errors.full_messages.to_sentence
      redirect_to new_transaction_path
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @categories = Category.all
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to transaction_path(@transaction)
    else
      flash[:error] = @transaction.errors.full_messages.to_sentence
      redirect_to edit_transaction_path
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to transactions_path
  end

  def import_form
  end

  def import
    file = params[:file]
    result = Transaction.create_from_import(file, current_user)
    flash[:error] = result[:error] if result[:error]
    redirect_to transactions_path
  end

  def export
    transactions = Transaction.where(user_id: current_user.id).order(transaction_date: :desc)
    xls = Transaction.generate_xls(transactions)
    send_data xls, filename: 'transactions.xlsx'
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :amount, :description, :category_id, :transaction_date, :receipt, :remove_receipt)
  end
end
