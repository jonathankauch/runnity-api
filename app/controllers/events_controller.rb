class EventsController < ApplicationController
  before_action :current_user
  before_action :set_event, only: [:show, :like, :dislike, :edit, :update, :destroy, :leave]

  # GET /events
  # GET /events.json
  def index
    @events = Event.where.not(id: current_user.events.ids + current_user.belongs_events.pluck(:id))
    @event = Event.new
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @post = Post.new
    @posts = @event.posts
    @is_member = @event.try(:members).exists?(:user_id => current_user.id)
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  def like
      @event = Event.find(params[:id])
      @event.liked_by current_user
      redirect_to :back
  end

  def dislike
      @event = Event.find(params[:id])
      @event.unliked_by current_user
      redirect_to :back
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    if !params[:event][:picture].nil?
      bucket = ENV['S3_BUCKET']
      pic = params[:event][:picture]
      content_type = pic.content_type.split('/').last

      if content_type == 'jpeg'
        content_type = 'jpg'
      end

      s3 = Aws::S3::Client.new(region: 'us-west-2')
      md5 = Digest::MD5.file(params[:event][:picture].tempfile).hexdigest
      filename = md5 + '.' + content_type
      s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                    acl: 'public-read', content_type: pic.content_type)
      link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename
      @event.pictures.new(name: filename, url: link)
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "L'événement a été mis à jour"}
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if !params[:event][:picture].nil?
      bucket = ENV['S3_BUCKET']
      pic = params[:event][:picture]
      content_type = pic.content_type.split('/').last

      if content_type == 'jpeg'
        content_type = 'jpg'
      end

      s3 = Aws::S3::Client.new(region: 'us-west-2')
      md5 = Digest::MD5.file(params[:event][:picture].tempfile).hexdigest
      filename = md5 + '.' + content_type
      s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                    acl: 'public-read', content_type: pic.content_type)
      link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename
      old_pic = @event.pictures.first
      old_pic.delete
      @event.pictures.new(name: filename, url: link)
    end

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def filter
    event_type = params[:type] == 2
    if !params[:type].blank?
      condition = ""
      if !params[:key_word].blank?
        condition += "lower(events.name) LIKE ? "
        condition += "and " if params[:type].to_i != 2
      end
      condition += "events.private_status is " + group_type if params[:type].to_i != 2
      print condition
      @events = Event.where(condition, "%" + params[:key_word].downcase + "%")
    end
    print @events.count
    respond_to do |format|
      format.js
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @success = @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.js
    end
  end

  def leave
    respond_to do |format|
      if @event.member_requests.find_by_user_id(current_user.id).destroy
        @errors = false
        format.js
      else
        @errors = true
        format.js
      end
    end
  end

  def filter
    event_type = params[:type] == "1" ? "true" : "false"
    if !params[:type].blank?
      condition = ""
      if !params[:key_word].blank?
        condition += "lower(events.name) LIKE ? "
        condition += "and " if params[:type].to_i != 2
      end
      condition += "events.private_status is " + event_type if params[:type].to_i != 2
      print condition
      @events = Event.where(condition, "%" + params[:key_word].downcase + "%")
      print @events.count
    end
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:user_id, :name, :description, :start_date, :end_date, :city, :private_status, :distance, :avatar)
    end
end
