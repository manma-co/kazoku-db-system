class Admin::SpreadSheetsController < Admin::AdminController
  def fetch_family
    credentials = Google::SpreadSheetAuthorizeService.credentials
    response = Google::SpreadSheetFetchService.fetch_family(credentials)
    Google::SpreadSheetStoreService.store_family_to_db(
      response, is_debug: false
    )

    redirect_to admin_family_index_path
  end

  # ‼︎!現在未使用 参加者をシステムで管理しなくなったため 20210809
  def fetch_participant
    credentials = Google::SpreadSheetAuthorizeService.credentials
    response = Google::SpreadSheetFetchService.fetch_participant(credentials)
    Google::SpreadSheetStoreService.store_participant_to_db(response, is_debug: false)

    redirect_to admin_participants_path
  end
end
