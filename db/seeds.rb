# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

emails = %w(yoshihito522@gmail.com takashiba@to-on.com shino@cps.im.dendai.ac.jp ricken0203@gmail.com)

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

locations = [
    '東京都墨田区押上1丁目1−2', #スカイツリー
    '千葉県千葉市美浜区中瀬2−1', #幕張メッセ
    '京都府京都市北区金閣寺町1', #金寺
    '広島県広島市中区大手町1−10', #原爆ドーム
    '石川県金沢市丸の内1-1', #金沢城
    '東京都足立区千住東2-17-1',
]

locations.each_with_index do |location, i|
  user = User.create(name: "no_name_#{i+1}", kana: 'no_name', gender: 0, is_family: true)
  Location.create(user_id: user.id, address: location)
  Contact.create(user_id: user.id, email_pc: "abc#{i+1}@pc.com", email_phone: "abc#{i+1}@phone.com")
  ProfileFamily.create(user_id: user.id, job_style: 1, number_of_children: i+1, is_photo_ok: 1, is_sns_ok: 1, is_male_ok: 1)
end

