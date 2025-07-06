class LogFilesController < ApplicationController
  before_action :set_log_file, only: [:show, :edit, :update, :destroy]

  def index
    @log_files = LogFile.recent.includes(:analyses)
  end

  def show
    @analyses = @log_file.analyses.includes(:error_patterns)
  end

  def new
    @log_file = LogFile.new
  end

  def create
    @log_file = LogFile.new(log_file_params)
    
    if params[:log_file][:file].present?
      file = params[:log_file][:file]
      @log_file.name = file.original_filename
      @log_file.file_size = file.size
      @log_file.file_path = "uploads/#{SecureRandom.uuid}/#{file.original_filename}"
      @log_file.uploaded_at = Time.current
      @log_file.file.attach(file)
    end

    if @log_file.save
      redirect_to @log_file, notice: 'Log file was successfully uploaded.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @log_file.update(log_file_params)
      redirect_to @log_file, notice: 'Log file was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @log_file.destroy
    redirect_to log_files_url, notice: 'Log file was successfully deleted.'
  end

  private

  def set_log_file
    @log_file = LogFile.find(params[:id])
  end

  def log_file_params
    params.require(:log_file).permit(:name, :description, :file)
  end
end