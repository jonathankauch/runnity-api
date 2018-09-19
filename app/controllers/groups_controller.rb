class GroupsController < ApplicationController
  before_action :current_user
  before_action :set_group, only: [:show, :like, :dislike, :edit, :update, :destroy, :leave]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.where.not(id: current_user.groups.ids + current_user.belongs_groups.pluck(:id))
    @group = Group.new
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @post = Post.new
    @posts = @group.posts
    @is_member = @group.try(:members).exists?(:user_id => current_user.id)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def like
    @group = Group.find(params[:id])
    @group.liked_by current_user
    redirect_to :back
  end

  def dislike
    @group = Group.find(params[:id])
    @group.unliked_by current_user
    redirect_to :back
  end

  # POST /groups
  # POST /groups.json
  def create
    group = Group.new(group_params)
    config = Config.new(params[:group][:config])

    respond_to do |format|
      if group.save
        config.group_id = group.id
        config.save
        format.html { redirect_to group, notice: 'Le groupe a été créé avec succès.' }
        format.json { render :show, status: :created, location: group }
      else
        format.html { render :new }
        format.json { render json: group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Le groupe a été mise à jour avec succès.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @success = @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url}
      format.js
    end
  end

  def leave
    respond_to do |format|
      if @group.member_requests.find_by_user_id(current_user.id).destroy
        @errors = false
        format.js
      else
        @errors = true
        format.js
      end
    end
  end

  def filter
    group_type = params[:type] == 2
    if !params[:type].blank?
      condition = ""
      if !params[:key_word].blank?
        condition += "lower(groups.name) LIKE ? "
        condition += "and " if params[:type].to_i != 2
      end
      condition += "groups.private_status is " + group_type if params[:type].to_i != 2
      print condition
      @groups = Group.where(condition, "%" + params[:key_word].downcase + "%")
    end
    print @groups.count
    respond_to do |format|
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:user_id, :name, :private_status, :description, :avatar, config_attributes: [ :is_invitable, :is_commentable])
  end
end
