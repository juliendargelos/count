class PeopleController < ApplicationController
  before_action :set_person, only: [:edit, :update, :destroy]

  def index
    @people = Person.all
  end

  def edit

  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new person_params

    if @person.save
      success :person_created
      redirect_to people_path
    else
      error :could_not_create_person
      render :new
    end
  end

  def update
    if @person.update person_params
      success :person_saved
      redirect_to people_path
    else
      error :cound_not_save_person
      render :edit
    end
  end

  def destroy
    if @person.destroy
      info :person_deleted
    else
      error :could_not_delete_person
    end

    redirect_to people_path
  end

  private

  def set_person
    @person = Person.find params[:id]
  end

  def person_params

    params.require(:person).permit :first_name, :last_name, :company, :email, :phone, :country, :city, :zipcode, :address
  end
end
