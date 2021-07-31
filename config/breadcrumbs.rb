crumb :root do
  link 'TOP', admin_family_index_path
end

crumb :admins do
  link '管理者一覧', admin_admin_index_path
end

crumb :new_admin do
  link '管理者新規作成', new_admin_admin_path
  parent :admins
end

crumb :families do
  link '家庭一覧', admin_family_index_path
end

crumb :family do |family|
  link "家庭詳細 : #{family.name}", admin_family_path(family)
  parent :families
end

crumb :edit_family do |family|
  link "家庭編集 : #{family.name}", edit_admin_family_path(family)
  parent :families
end

crumb :participant do |participant|
  link "参加者詳細 : #{participant.name}", admin_participant_path(participant)
  parent :participants
end

crumb :edit_participant do |participant|
  link "参加者編集 : #{participant.name}", edit_admin_participant_path(participant)
  parent :participants
end

crumb :locations do
  link '打診メール作成(家庭検索)', admin_locations_search_path
end

crumb :new_mail do
  link 'メール新規作成', ''
  parent :locations
end

crumb :confirm_mail do
  link '送信前メール確認', ''
  parent :locations
end

crumb :complete_mail do
  link 'メール送信完了', ''
  parent :locations
end

crumb :mail_histories do
  link 'メール送信履歴一覧', admin_mails_histories_path
end

crumb :mail_history do |mail_history|
  link "メール送信履歴詳細 : ##{mail_history.id}", admin_mails_history_path(mail_history)
  parent :mail_histories
end

crumb :news_letters do
  link 'ニュースレター', admin_news_letter_index_path
end

crumb :news_letter do |news_letter|
  link "ニュースレター詳細 : ##{news_letter.id}", admin_news_letter_path(news_letter)
  parent :news_letters
end

crumb :new_news_letter do
  link '新規ニュースレター作成', new_admin_news_letter_path
  parent :news_letters
end

crumb :edit_news_letter do |news_letter|
  link "ニュースレター編集 : ##{news_letter.id}", edit_admin_news_letter_path(news_letter)
  parent :news_letters
end

crumb :history_news_letters do
  link 'メール配信終了リスト', admin_news_history_path
  parent :news_letters
end
# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
