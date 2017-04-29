class Location < ApplicationRecord
  belongs_to :user

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  # 家族留学候補リストを取得する
  # @param [Hash] location 検索対象の位置情報
  # @param [Array] family_list 家族留学候補家庭リスト
  # @return [Hash] candidate_hash 家族留学候補家庭ハッシュ key: location, value: 距離
  def self.candidate_list(location, family_list)
    # 出発地
    dept = Hash.new
    dept[:lat] = location['lat']
    dept[:lng] = location['lng']

    candidate_hash = {}
    # 検索対象の位置情報リストを取得する
    locations = family_list.map { |f| f.user.location }
    locations.each do |n|
      # 目的地
      dist = Hash.new
      dist[:lat] = n.latitude
      dist[:lng] = n.longitude

      distance = distance_of_two_points(dept, dist)
      candidate_hash.store(n, distance)
    end
    candidate_hash.sort {|(k1, v1), (k2, v2)| v1 <=> v2 }
  end

  # 2点間の距離計算
  def self.distance_of_two_points(departure, destination)
    y1 = departure[:lat] * Math::PI / 180
    x1 = departure[:lng] * Math::PI / 180
    y2 = destination[:lat] * Math::PI / 180
    x2 = destination[:lng] * Math::PI / 180
    earth_r = 6378140

    deg = Math::sin(y1) * Math::sin(y2) + Math::cos(y1) * Math::cos(y2) * Math::cos(x2 - x1)
    earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
  end

end
