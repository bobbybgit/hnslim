module GroupCheck
  def self.check_group(group_sizes,player_count)
    combos = (1..group_sizes.length).flat_map{|size| group_sizes.combination(size).to_a}
    sums = combos.map{|combo| combo.sum}
    pp sums
    pp group_sizes[0]
    pp player_count
    sums.include?(player_count) || group_sizes[0] == player_count ? true : false
  end

end