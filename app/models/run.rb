class Run < ApplicationRecord
  belongs_to :user
  acts_as_votable

  validates :started_at, presence: true

#  after_create do
#    if self.max_speed == nil
#    elsif self.total_distance == nil
#      calculate_total_distance
#    end
#  end

  def update_av_speed
    kms = 0.0
    total_time_run = 0.0
    self.user.runs.each do |r|
      kms += r.total_distance
      total_time_run += r.total_time
    end
    average_speed = ((kms / 1000.0) / (total_time_run / 60.0)).round(2)
    if !average_speed.nan?
      self.user.update_attributes average_speed: average_speed
    end
  end

#  private

  #if a new run created but max_speed is missing, we should calculate max speed with data array
  #def calculate_max_speed
  #  if self.max_speed.nil?
  #    self.max_speed = 0
  #    self.coordonnates.each do |data|
  #      self.max_speed > data.speed ? self.max_speed = self.max_speed : self.max_speed = data.speed
  #    end
  #  end
  #end

  #if a new run created but total_distance is missing, we should calculate total_distance with data array
  #def calculate_total_distance
  #  if self.total_distance.nil?
  #    self.total_distance = 0
  #    self.coordonnates.each do |data|
  #      self.total_distance += data.distance
  #    end
  #  end
  #end

  #def runs_by_user(user)
  #    #to improve
  #    sql = "SELECT *
  #            FROM ( SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_at DESC, id DESC) AS r
  #                    FROM user WHERE run is not null and user = "+ self.id.to_s() +")t
  #            WHERE r = 1 AND userp_id  = "+ self.id.to_s() +" AND run = "+ run.to_s()
#
#      runs = User.find_by_sql(sql).map(&:user_id)
#
#    return Run.where(id: runs)
#  end

  # DOCUMENTATION
  include Swagger::Blocks

  swagger_schema :Run do
    key :required, [:id, :user_id]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :user_id do
      key :type, :integer
      key :format, :int64
    end
    property :started_at do
      key :type, :dateTime
      key :format, :dateTime
    end
    property :total_distance do
      key :type, :integer
      key :format, :dateTime
    end
    property :max_speed do
      key :type, :integer
      key :format, :int64
    end
    property :total_time do
      key :type, :integer
      key :format, :integer
    end
  end

  swagger_schema :RunInput do
    allOf do
      schema do
        key :'$ref', :Run
      end
      schema do
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end
end
