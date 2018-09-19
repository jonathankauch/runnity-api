class Achievement < ApplicationRecord
  belongs_to :user

  # there are several types
  # - weight => WEIGTH
  # - time => TIME
  # - kilometer => KILOMETER
  # - whatever => whatever
  def get_type_in_french
    type = ''
    if !self.achievement_type.nil?
      if self.achievement_type.downcase == 'weight'
        type = 'Poids'
      elsif self.achievement_type.downcase == 'time'
        type = 'Temps'
      elsif self.achievement_type.downcase == 'kilometer'
        type = 'Kilomètre'
      end
    else
      type = 'kilometer'
    end

    type
  end
end