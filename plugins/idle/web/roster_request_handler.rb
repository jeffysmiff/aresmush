module AresMUSH
  module Idle
    class RosterRequestHandler
      def handle(request)
                
        group = Global.read_config("website", "character_gallery_group") || "Faction"
        chars = Character.all.select { |c| c.on_roster? }.group_by { |c| c.group(group) || "" }
        
        roster = []
        
        chars.each do |group, chars|
          roster << {
            name: group,
            chars: chars.map { |c| build_profile(c) }
          } 
        end
        
        roster
      end
      
      def build_profile(char)
        demographics = {}
        Demographics.basic_demographics.sort.each { |d| 
            demographics[d.downcase] = char.demographic(d)
          }
        
        if (Ranks.is_enabled?)
          demographics['rank'] = char.rank
        end
          
        demographics['age'] = char.age
        demographics['birthdate'] = char.demographic(:birthdate)
        demographics['actor'] = char.demographic(:actor)
        
        groups = {}
        
        Demographics.all_groups.keys.sort.each { |g| 
          groups[g.downcase] = char.group(g)  
          }
        
          {
            name: char.name,
            fullname: char.demographic(:fullname),
            military_name: Ranks.military_name(char),
            icon: Website.icon_for_char(char),
            roster_notes: Website.format_markdown_for_html(char.roster_notes || ""),
            previously_played: char.roster_played,
            app_required: char.roster_restricted,
            contact: char.roster_contact,
            groups: groups,
            demographics: demographics,
        }        
      end
      
    end
  end
end