class AdminsBackoffice::AdminsController < AdminsBackofficeController
  before_action :passwordIsBlank, only: [:update] 
  before_action :set_admin, only: [:edit, :update, :destroy]
  
  def index
    @admins = Admin.all.page(params[:page]).per(5)
  end

  def edit
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params_admin)

    if @admin.save
      redirect_to admins_backoffice_admins_path, notice: "Saved with success !!"
    else
      render :new
    end    
  end

  def update
    if @admin.update(params_admin)
      redirect_to admins_backoffice_admins_path, notice: "Updated with success !!"
    else
      render :edit
    end
  end

  def destroy
    if @admin.destroy
      redirect_to admins_backoffice_admins_path, notice: "Deleted with success !!"
    else
      render :index
    end
  end

  private

  def passwordIsBlank
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].extract!(:password, :password_confirmation)
    end
  end
  def set_admin
    @admin = Admin.find(params[:id])
  end
  def params_admin
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
