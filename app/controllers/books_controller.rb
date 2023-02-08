class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @book_new=Book.new
    @user = @book.user
    @book_comment  = BookComment.new
    
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
  end

  def index
     @user = current_user
     to = Time.current.at_end_of_day
     from = (to - 6.day).at_beginning_of_day
     @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
     @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
        flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user=current_user
      render 'index'
    end
  end

  def edit
    book_id = Book.find(params[:id])
  unless book_id.user == current_user
    redirect_to books_path
  end

    @book = Book.find(params[:id])
  end

  def update
    book_id = Book.find(params[:id])
  unless book_id.user == current_user
    redirect_to books_path
  end

    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body , :user_id)
  end
 end