module GroupCheck
  def self.check_group(group_sizes,player_count)

    if group_sizes.include? player_count

      pp "includes"

      return true

    elsif player_count == 0

      pp "count = 0"

      return false

    else
      totals = group_sizes
      GroupCheck.generate_sums(totals, player_count) ? true : false


    end

    
    
  end

  def self.generate_sums(totals, player_count, original_tots = nil)
    original_tots = totals if !original_tots.present?
    pp totals
    tot_array = []
    pp "original totals = #{original_tots}"
    
    totals.each_with_index do |a, i|
      new_totals = []
      return true if a == player_count
      old_total = a
      
      original_tots.each do |b| 
        new_total = old_total + b
        pp "new total: #{new_total} player count: #{player_count}"
        return true if new_total == player_count
        new_totals.push(new_total) if (new_total == player_count)
      end
      tot_array[i] = new_totals
    end
    pp tot_array
    if !tot_array.flatten.empty?
      tot_array.each do |c|
        if (generate_sums(c, player_count, original_tots) if c != [])
          return true
        end
      end
    else
      false
    end
    false
  end

end