class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /groups or /groups.json
  def index
    @groups = current_user.groups.all.includes(:expenses)
    @total_expenses = current_user.groups.joins(:expenses).sum('expenses.amount')
  end

  def splash; end

  # GET /groups/1 or /groups/1.json
  def show
    @group = Group.find(params[:id])
    render 'show', locals: { group: @group }
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = current_user.groups.new(group_params)
    @group.icon.attach(params[:group][:icon])

    if @group.save
      redirect_to user_groups_path(current_user), notice: 'Category was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # def create
  #   @category = current_user.categories.new(category_params)
  #   @category.user = current_user
  #   @category.icon.attach(params[:category][:icon])

  #   if @category.save
  #     flash[:success] = 'category created successfully'
  #     redirect_to users_path(user_id: current_user.id)
  #   else
  #     flash[:alert] = 'error creating category'
  #   end
  # end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :icon)
    end
end
