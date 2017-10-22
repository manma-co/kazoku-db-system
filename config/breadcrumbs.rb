crumb :root do
  link 'TOP', admin_family_index_path
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

crumb :participants do
  link '参加者一覧', admin_participants_path
end

crumb :participant do |participant|
  link "参加者詳細 : #{participant.name}", admin_participant_path(participant)
  parent :participants
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