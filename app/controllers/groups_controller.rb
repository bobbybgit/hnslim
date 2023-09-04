class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :filter_groups, only: %i[table]

  # GET /groups or /groups.json
  def index
  end

  def table
    @memberships = Membership.all
  end

  # GET /groups/1 or /groups/1.json
  def show
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
    @group = Group.new(group_params)
   
    respond_to do |format|
      if @group.save 
        membership = current_user.memberships.new(:group_id => @group.id)
        @group.users.count == 0? membership[:admin] = true : membership[:admin] = false
        membership.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created.", data:{:turbo_frame => :content} }
        format.json { render :show, status: :created, location: @group }
      else 
        format.html { render :new, status: :unprocessable_entity, data:{:turbo_frame => :content} }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    memberships = Membership.all.where(group_id: @group.id)
    memberships.delete_all
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, data:{turbo_frame: "content"}, notice: "Group was successfully destroyed." }
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
      params.require(:group).permit(:name, :private, :location, :description)
    end

    def filter_groups

      params[:column] = "name" if !params[:column].present?
  
      case params[:column].downcase
      when "name"
        @groups = search_groups.order(:year)
      when "location"
        @groups = search_groups.order(:location)
      when "members"
        @groups = search_groups.joins(:memberships).group("groups.id").order("count(memberships.group_id) desc")
      else
        @games = search_games.order(:name)
        pp params[:column]
      end
      @groups = @groups.reverse if params[:direction] == "up" 
    end

    def search_groups
      (params[:my].to_s == "Show All Groups" || !params[:my].present?) ? groups = Group.all : groups = Group.all.by_user(current_user.id)
      params[:groups_filter].present? ? groups.group_search(params[:groups_filter]) : groups
    end
end
