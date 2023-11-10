class TransactionsController < ApplicationController
  include Xls
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
    transactions = Xls.import(file)

    transactions.each_with_index do |transaction, index|
      begin
        if index > 0
          category_id = Category.find_by(name: transaction[3]).id
          category_id = Category.find_by(name: 'Other').id if category_id.nil?
          Transaction.create!(
            name: transaction[0],
            amount: transaction[1],
            description: transaction[2],
            category_id: category_id,
            transaction_date: transaction[4],
            user_id: current_user.id
          )
        end
      rescue => e
        flash[:error] = "Error in row #{index + 1}: #{e.message}"
        redirect_to transaction_import_form_path
        return
      end
    end
    redirect_to transactions_path
  end

  def export
    transactions = Transaction.where(user_id: current_user.id).order(transaction_date: :desc)
    xls_rows = transactions.map do |transaction|
      category_name = Category.find(transaction.category_id).name
      [
        transaction.name,
        transaction.amount,
        transaction.description,
        category_name,
        transaction.transaction_date
      ]
    end
    headers = ['Name', 'Amount', 'Description', 'Category', 'Transaction Date']
    xls = Xls.export(headers, xls_rows)
    send_data xls, filename: 'transactions.xlsx'
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :amount, :description, :category_id, :transaction_date, :receipt, :remove_receipt)
  end
end
