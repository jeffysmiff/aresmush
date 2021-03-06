module AresMUSH
  class FS3Advantage < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    
    index :name
    
    def print_rating
      rating_name
    end
    
    def rating_name
      case rating
      when 0
        return t('fs3skills.everyman_rating')
      when 1
        return t('fs3skills.fair_rating')
      when 2
        return t('fs3skills.good_rating')
      when 3
        return t('fs3skills.exceptional_rating')
      end
    end
  end
end