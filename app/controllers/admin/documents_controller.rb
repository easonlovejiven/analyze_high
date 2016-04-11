# coding: utf-8
class Admin::DocumentsController < Admin::BaseController

  def index
  end

  def more_document
    @search = params[:search][:value] ? params[:search][:value] : ""
    @per_page = params[:per_page] ? params[:per_page] : 10
    page = params[:page] || 1
    start = params[:start].to_i || 0
    length = params[:length] ? params[:length].to_i : 10
    page = (start / length) + 1;
    @per_page = length;
    documents = Document.where(["file_file_name like ? and state = ?", "%%#{@search}%%", true]).paginate(page: page , per_page: @per_page).order("id DESC")
    data = documents.collect { |item| {:id => item.id, :file_name => item.file_file_name, :file_size => item.file_file_size, :created_at => item.created_at.strftime('%Y-%m-%d %H:%M:%S'), :status => item.show_status } }
    has_more = (documents.length == 0 ? false : true)
    all_count = documents.count
    draw = params[:draw].to_i + 1
    render :json => {:draw => draw, :has_more => has_more, :start => start, :recordsTotal => all_count, :recordsFiltered => all_count, :data => data }
  end 


  def new
    @document = Document.new
  end


  def edit
    @document = Document.find(params[:id])
  end


  def create
    @document = Document.new(document_params)
    if @document.save
      $redis.lpush("documents", @document.id)
      redirect_to admin_documents_url, notice: '新建成功！'
    else
      render :new
    end
  end


  def update
    @document = Document.find(params[:id])
    if @document.update(document_params)
      redirect_to admin_documents_url, notice: '编辑成功！'
    else
      render :edit
    end
  end 


  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to admin_documents_url
  end
  

  private

  def document_params
    params.require(:document).permit(:file, :status, :state)
  end
end