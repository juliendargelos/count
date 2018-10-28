class CompaniesController < ApplicationController
  before_action :set_company, only: [:edit, :update]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def edit

  end

  def update
    if @company.update company_params
      success :company_saved
    else
      error :could_not_save_company
    end

    redirect_to companies_path
  end

  def create
    @company = Company.new company_params

    if @company.save
      success :company_created
    else
      error :could_not_create_company
    end

    redirect_to companies_path
  end

  def destroy
    if @company.destroy
      info :company_deleted
    else
      error :could_not_delete_company
    end

    redirect_to companies_path
  end

  private

  def set_company
    @company = Company.find params[:id]
  end

  def company_params
    params.require(:company).permit :name, :notes
  end
end
