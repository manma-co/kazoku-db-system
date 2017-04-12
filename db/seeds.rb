# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

emails = ["yoshihito522@gmail.com", "takashiba@to-on.com"]
emails.each do |email|
  Admin.find_or_create_by(email: email)
end

domains = %w(
    専業主婦・専業主夫（パート・アルバイトは除く）
   メーカー（食品、飲料、繊維、木材、印刷、化学、鉄鋼、精密機器）
    飲食店・宿泊業・娯楽
    百貨店・ストア・専門店
    卸売・小売
    金融証券・保険
    情報＜メディア＞（マスコミ、新聞、出版、放送）
    情報＜IT＞（通信、IT）
    インフラ
    不動産
    医療・福祉
    教育・学習支援業
    専門サービス（税理士、弁護士、学術機関職員、広告、コンサル、人材など）
    公務員、官公庁
    自営業
    非営利団体
)
domains.each do |domain|
  JobDomain.create!(domain: domain)
end